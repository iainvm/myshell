pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

Singleton {
  id: root

  // settingsSearchLocations - Where to look for the settings file, in priority order
  // An entry is empty when its environment variable isn't set, and is skipped
  readonly property list<string> settingsSearchLocations: [
  envPath("MYSHELL_SETTINGS_FILE", ""),
  envPath("XDG_CONFIG_HOME", "/myshell/settings.json"),
  envPath("HOME", "/.config/myshell/settings.json"),
  ]

  // path - JSON file whose keys override the defaults below, reloaded on change
  // The first non-empty entry of settingsSearchLocations, even if that file doesn't exist
  readonly property string path: settingsSearchLocations.find(location => location !== "") ?? ""

  // envPath - The value of an environment variable with suffix appended, or "" if it's unset or empty
  function envPath(variable: string, suffix: string): string {
    const value = Quickshell.env(variable)
    return value ? value + suffix : ""
  }

  // Expose settings, one alias per top-level section
  property alias shell: adapter.shell
  property alias bar: adapter.bar

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
    }
  }

  function toggleBar() {
    bar.visible = !bar.visible
  }

  GlobalShortcut {
    name: "toggleBar"
    description: "Show or hide the top bar"
    onPressed: root.toggleBar()
  }
}
