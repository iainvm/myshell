pragma Singleton
import QtQuick

QtObject {
    readonly property var icons: ({
            "0": "󰂎",
            "10": "󰁺",
            "20": "󰁻",
            "30": "󰁼",
            "40": "󰁽",
            "50": "󰁾",
            "60": "󰁿",
            "70": "󰂀",
            "80": "󰂁",
            "90": "󰂂",
            "100": "󰁹",
            "error": "󰂃",
            "pending-charge": "󱈑",
            "charging": "󱐋",
    })

    function get(name) {
        return name in icons ? icons[name] : ""
    }
}
