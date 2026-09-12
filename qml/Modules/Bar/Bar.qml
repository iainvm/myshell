import Quickshell
import Quickshell.Hyprland
import QtQuick
import qs.Theme
import qs.Settings
import qs.Modules.Bar.Components.Battery
import qs.Modules.Bar.Components.DateTime

PanelWindow {
    id: root

    visible: Settings.isBarVisible // start hidden; toggle() flips this

    anchors {
        top: true
        left: true
        right: true
    }
    implicitHeight: 32
    color: Theme.mainBackgroundColor

    DateTime{
        id: dateTime
        anchors.centerIn: parent
    }

    Battery {
        id: battery
        anchors.right: parent.right
        anchors.rightMargin: 12
        anchors.verticalCenter: parent.verticalCenter
    }
}
