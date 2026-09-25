pragma Singleton
import QtQuick

QtObject {
    readonly property var icons: ({
            "search": "󰍉",
    })

    function get(name) {
        return name in icons ? icons[name] : ""
    }
}
