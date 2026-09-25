import QtQuick
import Quickshell.Bluetooth
import qs.Themes

Row {
    id: root

    property BluetoothDevice modelData
    readonly property bool busy: modelData !== null
        && (modelData.state === BluetoothDeviceState.Connecting
            || modelData.state === BluetoothDeviceState.Disconnecting)

    spacing: 8
    opacity: busy ? 0.5 : 1

    Text {
        id: deviceName
        anchors.verticalCenter: parent.verticalCenter
        color: Theme.textColor
        font.family: Theme.textFont
        font.pixelSize: 14
        text: root.modelData?.name ?? ""
    }

    Text {
        id: connectedIcon
        anchors.verticalCenter: parent.verticalCenter
        visible: root.modelData?.connected ?? false
        color: Theme.accentColor
        font.family: Theme.iconFont
        font.pixelSize: 16
        text: Icons.get("connected")
    }

    Text {
        id: deviceBattery
        anchors.verticalCenter: parent.verticalCenter
        visible: (root.modelData?.connected && root.modelData?.batteryAvailable) ?? false
        color: Theme.mutedTextColor
        font.family: Theme.textFont
        font.pixelSize: 14
        text: Math.round((root.modelData?.battery ?? 0) * 100) + "%"
    }
}
