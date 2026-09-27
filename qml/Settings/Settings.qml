pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

Singleton {
  id: root

  // settingsFileLocations - Where to look for the settings file, in priority order
  // An entry is empty when its environment variable isn't set, and is skipped
  readonly property list<string> settingsFileLocations: [
  envPath("MYSHELL_SETTINGS_FILE", ""),
  envPath("XDG_CONFIG_HOME", "/myshell/settings.json"),
  envPath("HOME", "/.config/myshell/settings.json"),
  ]

  // path - JSON file whose keys override the defaults below, reloaded on change
  // The first non-empty entry of settingsFileLocations, even if that file doesn't exist
  readonly property string path: settingsFileLocations.find(location => location !== "") ?? ""

  // envPath - The value of an environment variable with suffix appended, or "" if it's unset or empty
  function envPath(variable: string, suffix: string): string {
    const value = Quickshell.env(variable)
    return value ? value + suffix : ""
  }

  // Expose settings, one alias per top-level section
  property alias shell: adapter.shell
  property alias bar: adapter.bar
  property alias sideMenu: adapter.sideMenu
  property alias notifications: adapter.notifications

  FileView {
    id: file
    path: root.path
    watchChanges: true
    printErrors: false
    onFileChanged: reload()
    // loaded also fires for invalid JSON, which JsonAdapter already warns about, so only log a successful parse
    onLoaded: {
      try {
        JSON.parse(text())
        console.info("Loaded settings from", root.path)
      } catch (error) {}
    }
    onLoadFailed: error => {
      if (error !== FileViewError.FileNotFound) {
        console.warn("Failed to read settings from", root.path + ":", FileViewError.toString(error))
      }
    }

    JsonAdapter {
      id: adapter

      //
      // Shell Settings
      //
      property JsonObject shell: JsonObject {
        // mainMonitor
        // If empty the shell will render to all monitors
        // If populated it will render to the first monitor if finds that matches that model
        property list<string> mainMonitor: []
      }

      //
      // Bar Settings
      //
      property JsonObject bar: JsonObject {
        // visible - If the bar is currently visible on screen
        property bool visible: true

        //
        // Bar Time Settings
        //
        property JsonObject time: JsonObject {
          // enabled - If the bar renders the current time
          property bool enabled: true
          // format - What time format is shown normally
          property string format: "ddd dd MMM  hh:mm:ss"
          // hoverFormat - What time format is shown when hovering over the time
          property string hoverFormat: "yyyy-MM-dd'T'HH:mm:ssttt"
        }

        //
        // Bar Battery Settings
        //
        property JsonObject battery: JsonObject {
          // enabled - If the bar renders the battery status
          property bool enabled: true
          // maxCharge - The percentage the battery stops charging at, shows the pending-charge icon when reached
          property int maxCharge: 100
        }
      }

      //
      // Side Menu Settings
      //
      property JsonObject sideMenu: JsonObject {
        // visible - If the side menu is currently visible on screen
        property bool visible: false
      }

      //
      // Notifications Settings
      //
      property JsonObject notifications: JsonObject {
        // historySize - How many of the most recent notifications are kept in the history
        property int historySize: 10
        // timestampFormat - Qt format string for when a notification was received, shown when hovering over it
        property string timestampFormat: "yyyy-MM-dd HH:mm:ss"
      }
    }
  }

  // toggle - Flips a bool setting, given the section it's in and its name, e.g. toggle(bar, "visible")
  // A bool argument is only a copy of the value, so the section is needed to write the setting back
  function toggleVisibility(section: JsonObject) {
    section.visible = !section.visible
  }

  // sideMenuRequested - Emitted by openSideMenu, the side menu switches to the menu with this name
  signal sideMenuRequested(string menu)

  // openSideMenu - Opens the side menu on the menu with the given name, e.g. openSideMenu("Bluetooth")
  function openSideMenu(menu: string) {
    root.sideMenuRequested(menu)
    root.sideMenu.visible = true
  }

  GlobalShortcut {
    name: "toggleBar"
    description: "Show or hide the top bar"
    onPressed: root.toggleVisibility(root.bar)
  }

  GlobalShortcut {
    name: "toggleSideMenu"
    description: "Show or hide the side menu"
    onPressed: root.toggleVisibility(root.sideMenu)
  }

  GlobalShortcut {
    name: "openBluetoothSettings"
    description: "Open the side menu on the Bluetooth menu"
    onPressed: root.openSideMenu("Bluetooth")
  }

  GlobalShortcut {
    name: "openNetworkSettings"
    description: "Open the side menu on the Network menu"
    onPressed: root.openSideMenu("Network")
  }

  GlobalShortcut {
    name: "openApplicationsSettings"
    description: "Open the side menu on the Applications menu"
    onPressed: root.openSideMenu("Applications")
  }

  GlobalShortcut {
    name: "openNotificationsSettings"
    description: "Open the side menu on the Notifications menu"
    onPressed: root.openSideMenu("Notifications")
  }

  GlobalShortcut {
    name: "openVolumeSettings"
    description: "Open the side menu on the Volume menu"
    onPressed: root.openSideMenu("Volume")
  }
}
