import Quickshell
import QtQuick
import qs.Settings
import qs.Themes
import qs.Modules.Bar.Submodules.Time

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
}
