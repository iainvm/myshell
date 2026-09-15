import Quickshell
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.Theme

Rectangle {
    id: root
    color: Theme.mainBackgroundColor
    implicitHeight: 32

    Component.onCompleted: {
        // Ensure parent is ready before anchoring
        if (parent) {
            anchors.left = parent.left
            anchors.right = parent.right
        }
    }

    MouseArea{

        anchors.fill: parent

        onClicked: {
            // Sometimes headsets connect but don't fully connect
            // Battery info isn't available, usually when the device auto-connects but isn't trusted
            if (device.connected && !device.trusted && !device.batteryAvailable) {
                device.disconnect()
                device.connect()
            }
            if (device.connected) device.disconnect()
            if (!device.connected) device.connect()
        }

        RowLayout {
            anchors.centerIn: parent
            anchors.left: parent.left
            anchors.leftMargin: 8
            anchors.right: parent.right
            anchors.rightMargin: 8
            spacing: 10

            Text {
                text: name
                color: Theme.mainTextColor
                font.family: Theme.textFont
                font.pixelSize: 14
                Layout.fillWidth: true
            }

            Text {
                text: device.connected ? "󰂱" : (device.paired ? "󰂯" : "󰂲")
                font.family: Theme.iconFont
                color: Theme.mainTextColor
                font.pixelSize: 18
                opacity: 0.7
            }
        }
    }

}
