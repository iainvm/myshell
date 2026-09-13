import Quickshell
import Quickshell.Services.UPower
import QtQuick
import qs.Theme
import qs.Settings

MouseArea {
    id: root

    implicitWidth: 10
    height: parent.height

    enabled: true
    hoverEnabled: true

    // Battery Info
    readonly property UPowerDevice battery: UPower.displayDevice
    readonly property bool charging: battery.state == UPowerDeviceState.Charging
    readonly property bool pendingCharging: battery.state == UPowerDeviceState.PendingCharge
    readonly property real percentage: battery.percentage * 100

    // Icons
    readonly property string icon100Charging: "󰂅"
    readonly property string icon90Charging: "󰂋"
    readonly property string icon80Charging: "󰂊"
    readonly property string icon70Charging: "󰢞"
    readonly property string icon60Charging: "󰂉"
    readonly property string icon50Charging: "󰢝"
    readonly property string icon40Charging: "󰂈"
    readonly property string icon30Charging: "󰂇"
    readonly property string icon20Charging: "󰂆"
    readonly property string icon10Charging: "󰢜"
    readonly property string icon0Charging: "󰢟"
    readonly property string icon100: "󰁹"
    readonly property string icon90: "󰂂"
    readonly property string icon80: "󰂁"
    readonly property string icon70: "󰂀"
    readonly property string icon60: "󰁿"
    readonly property string icon50: "󰁾"
    readonly property string icon40: "󰁽"
    readonly property string icon30: "󰁼"
    readonly property string icon20: "󰁻"
    readonly property string icon10: "󰁺"
    readonly property string icon0: "󰂎"
    readonly property string iconBad: "󰂃"
    readonly property string iconHealth: "󱈑"
    readonly property string percentText: Math.round(percentage) + "%"

    Text {
        id: iconText
        visible: !root.containsMouse

        anchors.centerIn: parent
        anchors.verticalCenter: parent.verticalCenter
        color: Theme.mainTextColor
        font.family: Theme.iconFont

        text: {
            var icon = "icon" + (Math.floor(root.percentage / 10) * 10)
            // Add Charging Icon
            if (root.charging) {
                icon = icon + "Charging"
            }
            // If protected 80% charge, replace icon
            if (root.pendingCharging && root.percentage == 80) {
                return root.iconHealth
            }
            return root[icon]
        }

        font.pixelSize: {
            if (root.charging) return 29
            return 18
        }
    }

    Text {
        id: percentTextObj
        visible: root.containsMouse

        anchors.centerIn: parent
        anchors.verticalCenter: parent.verticalCenter

        text: root.percentText
        color: Theme.mainTextColor
        font.family: Theme.iconFont
        font.pixelSize: 13
    }
}
