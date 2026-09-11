import Quickshell
import Quickshell.Hyprland
import QtQuick
import qs.Theme
import qs.Settings

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

    Text {
        id: timeLabel
        anchors.centerIn: parent
        anchors.verticalCenter: parent.verticalCenter
        text: Qt.formatDateTime(new Date(), Settings.dateFormat)
        color: Theme.mainTextColor
        font.family: "monospace"
        font.pixelSize: 13
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: timeLabel.text = Qt.formatDateTime(new Date(), Settings.dateFormat)
    }
}
