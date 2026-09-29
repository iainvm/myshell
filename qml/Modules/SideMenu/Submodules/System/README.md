# System

The system settings have the power actions, and show how busy the computer is: the CPU usage, temperatures, and the busiest processes. The CPU usage uses the generic [Gauge](../../../../Components/Gauge/README.md).

## Features

- Power Off, Hibernate, Lock and Logout buttons are at the top of the page, they close the side menu and run their command straight away (no confirmation)
- While the page is open, pressing `P` powers off, `H` hibernates, `L` locks and `E` logs out (without Ctrl, Alt or Super held). The key is shown in the corner of each button
- The commands can be changed in the settings. By default Lock asks logind to lock the session (`loginctl lock-session`), so a screen locker (e.g. hypridle with hyprlock) must be listening for it, and Logout exits Hyprland
- A gauge shows the CPU usage, with the percentage under it
- The CPU and GPU temperatures are shown, from the `k10temp`/`coretemp`/`zenpower` and `amdgpu`/`radeon`/`nouveau`/`i915`/`xe` sensors, or `nvidia-smi` if it's installed. `N/A` is shown when there's no sensor
- The busiest processes (see `processCount`) are listed with their name, CPU usage and RAM usage (resident memory)
- A process's CPU usage is its share of the whole CPU (all cores), the same as the gauge
- Clicking the CPU heading orders the processes by CPU usage (the default), clicking the RAM heading orders them by RAM usage
- Everything is refreshed every `refreshInterval`, only while the page is open
- Each process has a kill button that kills the whole program it's part of, e.g. killing a vscode helper kills all of vscode. The program is found by going up the process's parents until the parent is systemd, Hyprland, the shell itself, or a shell (bash, zsh, ...), so a program run in a terminal (e.g. htop) is killed on its own, without the terminal
- When a process is part of a bigger program, the program's name is shown under it (e.g. `in codium`)
- Killing sends SIGTERM to the program and all of its child processes, then SIGKILL to any still running 5 seconds later
- systemd, Hyprland and the shell itself have no kill button. Kernel threads aren't listed
- Process names are the kernel's (cut to 15 characters), with Nix's wrapper naming removed (`.firefox-wrapped` is shown as `firefox`)
- Opened directly with the `quickshell:openSystemMenu` global shortcut

## Settings

Set under `system` in the [settings file](../../../../Settings/README.md#settings-file).

| Name             | Default                                         | Description                                                                                   |
|------------------|-------------------------------------------------|-----------------------------------------------------------------------------------------------|
| refreshInterval  | (int) 1000                                      | How often, in milliseconds, the CPU usage, temperatures and processes refresh.                |
| processCount     | (int) 5                                         | How many of the busiest processes are listed.                                                 |
| powerOffCommand  | (list) ["systemctl", "poweroff"]                | Command run by Power Off.                                                                     |
| hibernateCommand | (list) ["systemctl", "hibernate"]               | Command run by Hibernate.                                                                     |
| lockCommand      | (list) ["sh", "-c", "loginctl lock-session ..."] | Command run by Lock, locks the user's graphical session through logind.                      |
| logoutCommand    | (list) ["hyprctl", "dispatch", "hl.dsp.exit()"] | Command run by Logout, exits Hyprland (using Hyprland's Lua dispatcher syntax).               |
