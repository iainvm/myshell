import Quickshell
import Quickshell.Hyprland
import QtQuick
import qs.Theme
import qs.Settings
import qs.Modules.Bar.Components.Battery
import qs.Modules.Bar.Components.Bluetooth
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

    Row {
        id: rightSide
        height: root.height
        anchors.right: parent.right

        spacing: 5
        layoutDirection: Qt.RightToLeft

        Item {
            id: spacer
            width: 12
            height: root.height
        }

        Battery {
            id: battery
        }

        Bluetooth {
            id: bluetooth
        }
    }
}
