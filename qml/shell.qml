import Quickshell
import Quickshell.Hyprland
import QtQuick
import qs.Settings
import qs.Modules.Bar
import qs.Modules.SideMenu

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

  SideMenu {
    id: sideMenu
    screen: {
      const focused = Hyprland.focusedMonitor
      for (let i = 0; i < Quickshell.screens.length; i++){
        if (focused && Quickshell.screens[i].name == focused.name) return Quickshell.screens[i]
      }
      return root.screens[0]
    }
  }
}
