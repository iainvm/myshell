import Quickshell
import Quickshell.Bluetooth
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.Theme
import qs.Settings

MouseArea {
    id: root

    implicitWidth: 25
    height: parent.height

    // Bluetooth device
    readonly property BluetoothAdapter adapter: Bluetooth.defaultAdapter

    // Icons
    readonly property string iconOn: "󰂯"
    readonly property string iconOff: "󰂲"
    readonly property string iconConnected: "󰂱"

    property bool panelVisible: false
    onClicked: {
        panelVisible = !panelVisible
    }

    // Bluetooth Bar Icon
    Text {
        id: iconText

        anchors.centerIn: parent
        anchors.verticalCenter: parent.verticalCenter
        color: Theme.mainTextColor
        font.family: Theme.iconFont

        text: {
            if (root.adapter == null) {
                return root.iconOff
            }
            for (var i = 0; i < root.adapter.devices.values.length; i++) {
                let device = root.adapter.devices.values[i]
                if (device.connected) {
                    return root.iconConnected
                }
            }
            if (root.adapter.enabled) return root.iconOn
            return root.iconOff
        }

        font.pixelSize: 18
    }

    // Bluetooth Selector panel
    Panel {
        id: bluetoothPanel
        adapter: root.adapter
    }
}
