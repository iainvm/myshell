pragma Singleton
import QtQuick

QtObject {
    readonly property var icons: ({
            "remove": "󰧧",
    })

    function get(name) {
        return name in icons ? icons[name] : ""
    }
}
