import Quickshell
import QtQuick
import qs.Settings
import qs.Modules.Bar

ShellRoot {
  id: root

  Variants {
    model: {
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

    delegate: Component {
      Bar {}
    }
  }
}
