import Quickshell
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.Theme

Rectangle {
    id: root
    color: Theme.mainBackgroundColor
    implicitHeight: 32
    anchors {
        left: parent.left
        right: parent.right
    }

    MouseArea{

        anchors.fill: parent

        onClicked: {
            console.log("name: " + name)
            console.log("connected: " + connected)
            console.log("state: " + state)
            console.log("trusted: " + trusted)
            console.log("paired: " + paired)
            console.log("bonded: " + bonded)
            if (connected) {
                data.connect()
            }
            data.disconnect()
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
                text: connected ? "󰂱" : (paired ? "󰂯" : "󰂲")
                font.family: Theme.iconFont
                color: Theme.mainTextColor
                font.pixelSize: 18
                opacity: 0.7
            }
        }
    }

}
