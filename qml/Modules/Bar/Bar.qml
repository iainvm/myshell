import Quickshell
import QtQuick
import qs.Settings
import qs.Themes
import qs.Modules.Bar.Submodules.Time
import qs.Modules.Bar.Submodules.Battery
import qs.Modules.Bar.Submodules.Spacer

PanelWindow {
  id: root

  required property ShellScreen modelData

  screen: modelData
  visible: Settings.bar.visible

  anchors {
    top: true
    left: true
    right: true
  }
  implicitHeight: 32
  color: Theme.backgroundColor

  Time {
    id: time
    anchors.centerIn: parent
  }

  Row {
    id: right
    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter

    Battery {
      id: battery
    }

    Spacer {
      size: 12
    }
  }
}
