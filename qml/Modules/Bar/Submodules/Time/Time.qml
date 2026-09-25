import Quickshell
import QtQuick
import qs.Settings
import qs.Themes

MouseArea {
    id: root

    visible: Settings.barTimeEnabled
    implicitWidth: label.implicitWidth
    implicitHeight: label.implicitHeight
    hoverEnabled: Settings.barTimeHoverFormat !== ""

    readonly property string format: containsMouse ? Settings.barTimeHoverFormat : Settings.barTimeFormat

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
