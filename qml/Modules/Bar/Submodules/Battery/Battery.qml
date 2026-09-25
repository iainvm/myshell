import Quickshell
import Quickshell.Services.UPower
import QtQuick
import qs.Settings
import qs.Themes

MouseArea {
    id: root
    visible: Settings.bar.battery.enabled && device.isLaptopBattery

    readonly property UPowerDevice device: UPower.displayDevice
    readonly property int percentage: Math.round(device.percentage * 100)
    readonly property bool charging: device.state === UPowerDeviceState.Charging
    readonly property bool atMaxCharge: device.state === UPowerDeviceState.PendingCharge && percentage >= Settings.bar.battery.maxCharge

    readonly property string levelIcon: {
        if (!device.ready || !device.isPresent || device.state === UPowerDeviceState.Unknown) return Icons.get("error")
        if (atMaxCharge) return Icons.get("pending-charge")
        return Icons.get(String(Math.round(percentage / 10) * 10))
    }

    anchors.verticalCenter: parent.verticalCenter
    implicitWidth: Math.max(iconLabel.implicitWidth, percentageLabel.implicitWidth)
    implicitHeight: Math.max(iconLabel.implicitHeight, percentageLabel.implicitHeight)
    hoverEnabled: true

    Text {
        id: iconLabel
        anchors.centerIn: parent
        visible: !root.containsMouse
        color: Theme.textColor
        font.family: Theme.iconFont
        font.pixelSize: 18
        text: (root.charging ? Icons.get("charging") : "") + root.levelIcon
    }

    Text {
        id: percentageLabel
        anchors.centerIn: parent
        visible: root.containsMouse
        color: Theme.textColor
        font.family: Theme.textFont
        font.pixelSize: 15
        text: root.percentage + "%"
    }
}
