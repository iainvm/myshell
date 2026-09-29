pragma Singleton
import QtQuick

QtObject {
    readonly property var icons: ({
            "powerOff": "󰐥",
            "hibernate": "󰒲",
            "lock": "󰌾",
            "logout": "󰍃",
            "cpu": "󰍛",
            "gpu": "󰢮",
            "temperature": "󰔏",
            "kill": "󰅖",
            "sorted": "󰁅",
    })

    function get(name) {
        return name in icons ? icons[name] : ""
    }
}
