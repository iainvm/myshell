# Settings

The settings draw is a panel that anchored to the right side of the screen
It contains a drop down menu at the top, which when a page is picked the rest of the panel shows a scrollable area with the settings for that page

## Features

- Settings split into pages, picked from a drop down menu (the generic [MenuSwitcher](../../Components/MenuSwitcher/README.md)), to only show what you need
- Hides when focus is clicked off of it, or when Escape is pressed (Escape closes the drop down menu first if it's open)
- Toggled with the `quickshell:toggleSettings` global shortcut
- Opened on a specific menu with `Settings.openSettings("<menu name>")`, e.g. the `quickshell:openBluetoothSettings` global shortcut opens it on Bluetooth
- Opens on the main monitor chosen by [`shell.mainMonitor`](../../Settings/README.md#shell), or on the focused monitor if the shell is on every monitor
- Each time it opens the current page is rebuilt, so searches are cleared

## Settings

Set under `settings` in the [settings file](../../Settings/README.md#settings-file).

| Name    | Default        | Description                                                    |
|---------|----------------|----------------------------------------------------------------|
| visible | (boolean) true | If the settings drawer is currently visible (open on startup). |

## Submodules

Each submodule is a page in the drop down menu, added to the `menus` list in `Settings.qml`.

- [Bluetooth](./Submodules/Bluetooth/README.md)
