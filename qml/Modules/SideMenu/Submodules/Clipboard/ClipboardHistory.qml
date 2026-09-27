pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import qs.Settings

Singleton {
  id: root

  // size - How many of the most recent clipboard entries are shown, the newest first
  readonly property int size: Math.max(0, Settings.clipboard.historySize)
  // imageDirectory - Where decoded images are saved, one file per entry id, so they can be shown as previews
  readonly property string imageDirectory: Quickshell.cachePath("clipboard-images")
  // entries - The clipboard history, newest first
  // Each has: id, text (a preview of the contents, or a description of an image), and for images: image (true), format, width, height, bytes
  property var entries: []

  // removing - Ids that have been deleted, hidden from entries in case a list started before they were gone
  // cliphist never reuses an id, so they're never cleared
  property var removing: []
  property var pendingRemovals: []
  property bool refreshPending: false

  // cliphist - The cliphist command, using the user's own cliphist database and config, which the cliphist service stores the clipboard in
  readonly property string cliphist: "cliphist -preview-width 1000"

  // imagePath - The file the image of an entry is decoded to
  function imagePath(entry: var): string {
    return root.imageDirectory + "/" + entry.id
  }

  // parse - Turns a line of `cliphist list` into an entry, e.g. "5\t[[ binary data 144 B png 20x10 ]]"
  function parse(line: string): var {
    const tab = line.indexOf("\t")
    const entry = { id: line.slice(0, tab), text: line.slice(tab + 1), image: false }
    const image = entry.text.match(/^\[\[ binary data (.+) (\w+) (\d+)x(\d+) \]\]$/)
    if (image) {
      entry.image = true
      entry.bytes = image[1]
      entry.format = image[2]
      entry.width = Number(image[3])
      entry.height = Number(image[4])
      entry.text = "Image " + image[2] + " " + image[3] + "x" + image[4]
    }
    return entry
  }

  function refresh() {
    if (lister.running) {
      root.refreshPending = true
    } else {
      lister.running = true
    }
  }

  // copy - Puts an entry back on the clipboard, which the cliphist service then moves to the top of the history
  // Detached, as wl-copy keeps running in the background to serve the clipboard
  function copy(entry: var) {
    const type = entry.image ? "image/" + entry.format : "text/plain;charset=utf-8"
    Quickshell.execDetached(["sh", "-c", root.cliphist + " decode \"$1\" | wl-copy --type \"$2\"", "sh", entry.id, type])
  }

  function remove(entry: var) {
    root.removing = root.removing.concat([entry.id])
    root.pendingRemovals = root.pendingRemovals.concat([entry.id])
    root.entries = root.entries.filter(existing => existing.id !== entry.id)
    root.startRemoval()
  }

  function startRemoval() {
    if (remover.running || root.pendingRemovals.length === 0) return
    remover.command = ["sh", "-c", remover.script, "sh"].concat(root.pendingRemovals)
    root.pendingRemovals = []
    remover.running = true
  }

  onSizeChanged: root.refresh()

  // The cliphist service is told about a clipboard change at the same time as the watchers, so wait for it to store the change before listing
  Timer {
    id: refreshDelay
    interval: 300
    onTriggered: root.refresh()
  }

  // Print a line on every clipboard change, one for text and one for images (plain wl-paste skips image only clipboards), so the list is refreshed
  Process {
    id: textWatcher
    running: true
    command: ["wl-paste", "--watch", "echo", "changed"]
    stdout: SplitParser {
      onRead: refreshDelay.restart()
    }
    onExited: (exitCode, exitStatus) => console.warn("Clipboard text watcher stopped with exit code", exitCode)
  }

  Process {
    id: imageWatcher
    running: true
    command: ["wl-paste", "--type", "image", "--watch", "echo", "changed"]
    stdout: SplitParser {
      onRead: refreshDelay.restart()
    }
    onExited: (exitCode, exitStatus) => console.warn("Clipboard image watcher stopped with exit code", exitCode)
  }

  // Lists the most recent entries, decodes any new images among them, removes the images of entries no longer shown, then prints the list
  Process {
    id: lister

    readonly property string script: [
    "c() { " + root.cliphist + " \"$@\"; }",
    "list=$(c list 2>/dev/null | head -n \"$1\")",
    "mkdir -p \"$2\"",
    "printf '%s\\n' \"$list\" | grep -E '^[0-9]+\t\\[\\[ binary data .* [0-9]+x[0-9]+ \\]\\]$' | cut -f1 | while read -r id; do",
    "  [ -s \"$2/$id\" ] || { c decode \"$id\" > \"$2/$id.tmp\" && mv \"$2/$id.tmp\" \"$2/$id\"; }",
    "done",
    "for file in \"$2\"/*; do",
    "  [ -e \"$file\" ] || continue",
    "  printf '%s\\n' \"$list\" | grep -q \"^${file##*/}\t\" || rm -f \"$file\"",
    "done",
    "printf '%s\\n' \"$list\"",
    ].join("\n")

    command: ["sh", "-c", script, "sh", String(root.size), root.imageDirectory]
    stdout: StdioCollector {
      id: listOutput
    }
    onExited: {
      root.entries = listOutput.text.split("\n")
      .filter(line => line.includes("\t"))
      .map(line => root.parse(line))
      .filter(entry => !root.removing.includes(entry.id))
      // console.info("DEBUGCLIP", JSON.stringify(root.entries.map(entry => entry.text)))
      if (root.refreshPending) {
        root.refreshPending = false
        lister.running = true
      }
    }
  }

  // Deletes the entries with the ids given as arguments
  Process {
    id: remover

    readonly property string script: "for id; do printf '%s\\t\\n' \"$id\"; done | " + root.cliphist + " delete"

    onExited: {
      root.startRemoval()
      root.refresh()
    }
  }

  Component.onCompleted: root.refresh()
}
