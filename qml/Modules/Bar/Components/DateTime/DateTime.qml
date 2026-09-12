import Quickshell
import QtQuick
import qs.Theme
import qs.Settings

Item {
    id: root

    implicitWidth: timeLabel.implicitWidth
    implicitHeight: timeLabel.implicitHeight

    Text {
        id: timeLabel
        anchors.centerIn: parent
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
        onTriggered: timeLabel.text = Qt.formatDateTime(
            new Date(),
            Settings.dateFormat,
        )
    }
}
