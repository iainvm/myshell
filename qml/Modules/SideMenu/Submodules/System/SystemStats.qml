import QtQuick
import Quickshell
import Quickshell.Io
import qs.Settings

// Samples the CPU usage, temperatures and running processes, only while it exists (so only while the System menu is open)
Item {
  id: root

  // cpuUsage - Percentage of the whole CPU in use since the last sample, -1 until there are two samples to compare
  property real cpuUsage: -1
  // cpuTemperature, gpuTemperature - In degrees Celsius, NaN when there's no sensor for it
  property real cpuTemperature: NaN
  property real gpuTemperature: NaN
  // processes - Every user space process, each has: pid, ppid, name, cpu (percentage of the whole CPU), memory (resident bytes), startTime
  property var processes: []
  // byPid - The same processes, looked up by pid
  property var byPid: ({})
  // selfPid - The shell's own process, which is never killed
  property int selfPid: -1

  property var previousCpu: null
  property var previousTicks: ({})
  property bool sampled: false

  // shells - Process names treated as shells, a process started from one is its own program rather than part of the shell's program
  readonly property list<string> shells: ["sh", "bash", "zsh", "fish", "dash", "ksh", "mksh", "tcsh", "csh", "nu", "elvish", "xonsh", "ysh", "osh"]

  // displayName - A process name without the Nix wrapper around it, e.g. ".firefox-wrappe" is "firefox"
  // Kernel process names are cut to 15 characters, so "-wrapped" may be cut short too
  function displayName(name: string): string {
    const match = name.match(/^\.(.+?)-(?:w|wr|wra|wrap|wrapp|wrappe|wrapped)$/)
    return match ? match[1] : name
  }

  // isSessionProcess - If a process belongs to the session rather than an app: init, systemd, the compositor, or this shell
  function isSessionProcess(process: var): bool {
    return process.pid === 1 || process.name === "systemd" || /hyprland/i.test(process.name) || process.pid === root.selfPid
  }

  function isShell(process: var): bool {
    return root.shells.includes(process.name)
  }

  // programOf - The top process of the program a process is part of, found by walking up its parents until the parent is a session process or a shell
  // e.g. a vscode helper gives the main vscode process, htop run in a terminal gives htop. Null for session processes, which can't be killed
  function programOf(pid: int): var {
    let current = root.byPid[pid]
    if (!current || root.isSessionProcess(current)) return null
    while (true) {
      const parent = root.byPid[current.ppid]
      if (!parent || root.isSessionProcess(parent) || root.isShell(parent)) return current
      current = parent
    }
  }

  // treeOf - A process and all of its descendants
  function treeOf(pid: int): var {
    const tree = []
    const pending = [pid]
    while (pending.length > 0) {
      const current = pending.pop()
      const process = root.byPid[current]
      if (!process) continue
      tree.push(process)
      for (const child of root.processes) {
        if (child.ppid === current) pending.push(child.pid)
      }
    }
    return tree
  }

  // kill - Kills the whole program a process is part of: every process in its tree is sent SIGTERM, and any still running 5 seconds later SIGKILL
  // Each process is passed with its start time, so a pid reused by a new process in the meantime isn't killed
  function kill(pid: int) {
    const program = root.programOf(pid)
    if (!program) return
    const targets = root.treeOf(program.pid).map(process => process.pid + ":" + process.startTime)
    console.info("Killing", program.name, "(" + program.pid + ") and", targets.length - 1, "descendants")
    Quickshell.execDetached(["sh", "-c", killer.script, "sh"].concat(targets))
    refreshSoon.restart()
  }

  function refresh() {
    if (!sampler.running) sampler.running = true
  }

  function parse(output: string) {
    const lines = output.split("\n")
    let pageSize = 4096
    let cpuTemperature = NaN
    let gpuTemperature = NaN
    let cpuLine = ""
    let index = 0
    for (; index < lines.length; index++) {
      const line = lines[index]
      if (line === "processes") break
      const [kind, value] = [line.slice(0, line.indexOf(" ")), line.slice(line.indexOf(" ") + 1)]
      if (kind === "self") root.selfPid = Number(value)
      else if (kind === "page") pageSize = Number(value) || 4096
      else if (kind === "cpu") cpuLine = value
      else if (kind === "cputemp" && isNaN(cpuTemperature) && value !== "") cpuTemperature = Number(value) / 1000
      else if (kind === "gputemp" && isNaN(gpuTemperature) && value !== "") gpuTemperature = Number(value) / 1000
    }

    // "cpu  user nice system idle iowait irq softirq steal guest guest_nice", guest time is already counted in user
    const times = cpuLine.trim().split(/\s+/).slice(1, 9).map(Number)
    const cpu = { total: times.reduce((sum, time) => sum + time, 0), idle: times[3] + times[4] }
    const elapsed = root.previousCpu ? cpu.total - root.previousCpu.total : 0
    if (elapsed > 0) {
      root.cpuUsage = Math.max(0, Math.min(100, 100 * (1 - (cpu.idle - root.previousCpu.idle) / elapsed)))
    }

    // "pid (name) state ppid ...", the name can contain spaces and brackets, so it ends at the last ")"
    const processes = []
    const byPid = {}
    const ticks = {}
    for (index++; index < lines.length; index++) {
      const line = lines[index]
      const open = line.indexOf("(")
      const close = line.lastIndexOf(")")
      if (open === -1 || close === -1) continue
      const pid = Number(line.slice(0, open))
      const fields = line.slice(close + 2).split(" ")
      const ppid = Number(fields[1])
      // Skip kernel threads, children of kthreadd
      if (pid === 2 || ppid === 2) continue
      const used = Number(fields[11]) + Number(fields[12])
      ticks[pid] = used
      const previous = root.previousTicks[pid]
      const process = {
        pid: pid,
        ppid: ppid,
        name: root.displayName(line.slice(open + 1, close)),
        cpu: elapsed > 0 && previous !== undefined ? Math.max(0, 100 * (used - previous) / elapsed) : 0,
        memory: Number(fields[21]) * pageSize,
        startTime: fields[19],
      }
      processes.push(process)
      byPid[pid] = process
    }

    root.previousCpu = cpu
    root.previousTicks = ticks
    root.cpuTemperature = cpuTemperature
    root.gpuTemperature = gpuTemperature
    root.byPid = byPid
    root.processes = processes
    root.sampled = true
  }

  // The first sample only gives a starting point for the CPU usage, so the second is taken soon after
  Timer {
    id: sampleTimer
    running: true
    repeat: true
    triggeredOnStart: true
    interval: root.cpuUsage < 0 ? 250 : Math.max(250, Settings.system.refreshInterval)
    onTriggered: root.refresh()
  }

  Timer {
    id: refreshSoon
    interval: 500
    onTriggered: root.refresh()
  }

  Process {
    id: sampler

    readonly property string script: [
    "echo \"self $PPID\"",
    "echo \"page $(getconf PAGESIZE 2>/dev/null || echo 4096)\"",
    "echo \"cpu $(head -n 1 /proc/stat)\"",
    "for dir in /sys/class/hwmon/hwmon*; do",
    "  case \"$(cat \"$dir/name\" 2>/dev/null)\" in",
    "    k10temp|coretemp|zenpower|cpu_thermal) echo \"cputemp $(cat \"$dir/temp1_input\" 2>/dev/null)\" ;;",
    "    amdgpu|radeon|nouveau|i915|xe) echo \"gputemp $(cat \"$dir/temp1_input\" 2>/dev/null)\" ;;",
    "  esac",
    "done",
    "if command -v nvidia-smi >/dev/null 2>&1; then",
    "  temperature=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits 2>/dev/null | head -n 1)",
    "  [ -n \"$temperature\" ] && echo \"gputemp ${temperature}000\"",
    "fi",
    "echo processes",
    "cat /proc/[0-9]*/stat 2>/dev/null",
    "true",
    ].join("\n")

    command: ["sh", "-c", script]
    stdout: StdioCollector {
      id: samplerOutput
      onStreamFinished: root.parse(samplerOutput.text)
    }
  }

  // Arguments are "pid:starttime", the start time is field 22 of /proc/<pid>/stat, the 20th after the name
  QtObject {
    id: killer

    readonly property string script: [
    "for entry; do kill -TERM \"${entry%%:*}\" 2>/dev/null; done",
    "sleep 5",
    "for entry; do",
    "  pid=${entry%%:*}",
    "  stat=$(cat \"/proc/$pid/stat\" 2>/dev/null) || continue",
    "  set -- ${stat##*) }",
    "  [ \"${20}\" = \"${entry#*:}\" ] && kill -KILL \"$pid\" 2>/dev/null",
    "done",
    "true",
    ].join("\n")
  }
}
