# Side Menu

The side menu is a panel that anchored to the right side of the screen
It contains a drop down menu at the top, which when a page is picked the rest of the panel shows a scrollable area with that page

## Features

- Split into pages, picked from a drop down menu (the generic [MenuSwitcher](../../Components/MenuSwitcher/README.md)), to only show what you need
- Hides when focus is clicked off of it, or when Escape is pressed (Escape closes the drop down menu first if it's open)
- Toggled with the `quickshell:toggleSideMenu` global shortcut
- Opened on a specific menu with `Settings.openSideMenu("<menu name>")`, e.g. the `quickshell:openBluetoothSettings` global shortcut opens it on Bluetooth, `quickshell:openNetworkSettings` on Network, `quickshell:openApplicationsSettings` on Applications, `quickshell:openNotificationsSettings` on Notifications, and `quickshell:openVolumeSettings` on Volume
- Opens on the main monitor chosen by [`shell.mainMonitor`](../../Settings/README.md#shell), or on the focused monitor if the shell is on every monitor
- Each time it opens the current page is rebuilt, so searches are cleared

## Settings

Set under `sideMenu` in the [settings file](../../Settings/README.md#settings-file).

| Name    | Default         | Description                                              |
|---------|-----------------|----------------------------------------------------------|
| visible | (boolean) false | If the side menu is currently visible (open on startup). |

## Submodules

Each submodule is a page in the drop down menu, added to the `menus` list in `SideMenu.qml`.

- [Bluetooth](./Submodules/Bluetooth/README.md)
- [Network](./Submodules/Network/README.md)
- [Applications](./Submodules/Applications/README.md)
- [Notifications](./Submodules/Notifications/README.md)
- [Volume](./Submodules/Volume/README.md)
