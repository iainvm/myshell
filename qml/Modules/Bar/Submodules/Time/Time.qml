import Quickshell
import QtQuick
import qs.Settings
import qs.Themes

MouseArea {
    id: root

    visible: Settings.bar.time.enabled
    implicitWidth: label.implicitWidth
    implicitHeight: label.implicitHeight
    hoverEnabled: Settings.bar.time.hoverFormat !== ""

    readonly property string format: containsMouse ? Settings.bar.time.hoverFormat : Settings.bar.time.format

    SystemClock {
        id: clock
        enabled: root.visible
        precision: SystemClock.Seconds
    }

    Text {
        id: label
        anchors.centerIn: parent
        color: Theme.textColor
        font.family: Theme.textFont
        font.pixelSize: 13
        text: Qt.formatDateTime(clock.date, root.format)
    }
}
