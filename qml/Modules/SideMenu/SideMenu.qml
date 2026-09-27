import Quickshell
import Quickshell.Hyprland
import QtQuick
import qs.Settings
import qs.Themes
import qs.Components.MenuSwitcher
import qs.Modules.SideMenu.Submodules.Bluetooth
import qs.Modules.SideMenu.Submodules.Network
import qs.Modules.SideMenu.Submodules.Applications
import qs.Modules.SideMenu.Submodules.Notifications
import qs.Modules.SideMenu.Submodules.Volume
import qs.Modules.SideMenu.Submodules.Clipboard

PanelWindow {
  id: root

  // notificationHistory - Referenced so the history starts collecting notifications with the drawer, not when the page is first opened
  readonly property QtObject notificationHistory: NotificationHistory
  // clipboardHistory - Referenced so the clipboard history is recorded from when the shell starts, not when the page is first opened
  readonly property QtObject clipboardHistory: ClipboardHistory

  function close() {
    Settings.sideMenu.visible = false
  }

  visible: Settings.sideMenu.visible
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

    function onSideMenuRequested(menu: string) {
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
        name: "Applications"
        icon: "󰀻"
        component: Applications {}
      },
      Menu {
        name: "Bluetooth"
        icon: "󰂯"
        component: Bluetooth {}
      },
      Menu {
        name: "Clipboard"
        icon: "󰅌"
        component: Clipboard {}
      },
      Menu {
        name: "Network"
        icon: "󰖩"
        component: Network {}
      },
      Menu {
        name: "Notifications"
        icon: "󰂚"
        component: Notifications {}
      },
      Menu {
        name: "Volume"
        icon: "󰕾"
        component: Volume {}
      }
      ]
    }
  }
}
