import Quickshell
import Quickshell.Hyprland
import QtQuick
import qs.Settings
import qs.Modules.Bar
import qs.Modules.Settings

ShellRoot {
  id: root

  readonly property list<ShellScreen> screens: {
    if (Settings.shell.mainMonitor.length == 0) return Quickshell.screens
    for (let i = 0; i < Settings.shell.mainMonitor.length; i++){
      let monitor = Settings.shell.mainMonitor[i]
      for (let j = 0; j < Quickshell.screens.length; j++){
        let screen = Quickshell.screens[j]
        if (screen.model == monitor) return [screen]
      }
    }
    return Quickshell.screens
  }

  Variants {
    model: root.screens

    delegate: Component {
      Bar {}
    }
  }

  Settings {
    id: settings
    screen: {
      if (root.screens.length == 1) return root.screens[0]
      const focused = Hyprland.focusedMonitor
      for (let i = 0; i < root.screens.length; i++){
        if (focused && root.screens[i].name == focused.name) return root.screens[i]
      }
      return root.screens[0]
    }
  }
}
