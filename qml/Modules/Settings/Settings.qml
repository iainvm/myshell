import Quickshell
import Quickshell.Hyprland
import QtQuick
import qs.Settings
import qs.Themes
import qs.Components.MenuSwitcher
import qs.Modules.Settings.Submodules.Bluetooth

PanelWindow {
  id: root

  function close() {
    Settings.settings.visible = false
  }

  visible: Settings.settings.visible
  focusable: true
  color: Theme.backgroundColor

  anchors {
    top: true
    right: true
    bottom: true
  }
  implicitWidth: 360

  HyprlandFocusGrab {
    id: focusGrab
    windows: [root]
    active: root.visible
    onCleared: root.close()
  }

  Connections {
    id: menuRequests
    target: Settings

    function onSettingsMenuRequested(menu: string) {
      menuSwitcher.show(menu)
    }
  }

  Item {
    id: content
    anchors.fill: parent
    anchors.margins: 12
    focus: true
    Keys.onEscapePressed: root.close()

    MenuSwitcher {
      id: menuSwitcher
      anchors.fill: parent
      active: root.visible
      menus: [
      Menu {
        name: "Bluetooth"
        icon: "󰂯"
        component: Bluetooth {}
      }
      ]
    }
  }
}
