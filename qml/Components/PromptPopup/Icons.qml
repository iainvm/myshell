pragma Singleton
import QtQuick

QtObject {
    readonly property var icons: ({
            "show": "󰈈",
            "hide": "󰈉",
    })

    function get(name) {
        return name in icons ? icons[name] : ""
    }
}
