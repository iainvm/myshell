pragma Singleton
import QtQuick

QtObject {
    readonly property var icons: ({
            "connected": "󰂱",
    })

    function get(name) {
        return name in icons ? icons[name] : ""
    }
}
