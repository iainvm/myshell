pragma Singleton
import QtQuick

QtObject {
    readonly property var icons: ({
            "connected": "󰗠",
            "saved": "󰆓",
            "wired": "󰈀",
            "signal0": "󰤯",
            "signal1": "󰤟",
            "signal2": "󰤢",
            "signal3": "󰤥",
            "signal4": "󰤨",
            "signal0Locked": "󰤬",
            "signal1Locked": "󰤡",
            "signal2Locked": "󰤤",
            "signal3Locked": "󰤧",
            "signal4Locked": "󰤪",
    })

    function get(name) {
        return name in icons ? icons[name] : ""
    }
}
