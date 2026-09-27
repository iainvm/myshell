pragma Singleton
import QtQuick

QtObject {
    readonly property var icons: ({
            "output": "󰕾",
            "outputMuted": "󰖁",
            "input": "󰍬",
            "inputMuted": "󰍭",
            "art": "󰎆",
            "play": "󰐊",
            "pause": "󰏤",
            "next": "󰒭",
            "previous": "󰒮",
            "switchPlayer": "󰓡",
    })

    function get(name) {
        return name in icons ? icons[name] : ""
    }
}
