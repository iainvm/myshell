pragma Singleton
import QtQuick

QtObject {
    readonly property var icons: ({
            "closed": "󰅀",
            "open": "󰅃",
    })

    function get(name) {
        return name in icons ? icons[name] : ""
    }
}
