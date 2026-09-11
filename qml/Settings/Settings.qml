pragma ComponentBehavior: Bound
pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Hyprland

Singleton {
    id: root

    property bool isBarVisible: false
    // property bool isDrawerVisible: false

    function toggle() {
        isBarVisible = !isBarVisible
    }

    GlobalShortcut {
        name: "toggleBar"
        description: "Show or hide the top bar"
        onPressed: root.toggle()
    }

    readonly property string dateFormat: "ddd dd MMM  hh:mm:ss"
}
