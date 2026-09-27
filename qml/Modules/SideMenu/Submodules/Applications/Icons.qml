pragma Singleton
import QtQuick

QtObject {
    readonly property var icons: ({
            "placeholder": "󰀻",
            "favourite": "",
            "notFavourite": "",
    })

    function get(name) {
        return name in icons ? icons[name] : ""
    }
}
