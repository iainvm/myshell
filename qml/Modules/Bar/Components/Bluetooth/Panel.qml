import Quickshell
import Quickshell.Bluetooth
import Quickshell.Hyprland
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.Theme

PanelWindow {
    id: bluetoothSelector
    visible: root.panelVisible
    color: Theme.mainBackgroundColor
    aboveWindows: true
    focusable: true
    HyprlandFocusGrab {
        windows: [bluetoothSelector]
        active: root.panelVisible

        onCleared: root.panelVisible = false
    }
    anchors {
        top: true
        right: true
    }
    implicitWidth: 300
    implicitHeight: 200

    property BluetoothAdapter adapter
    ListModel {
        id: filteredDevices
        //TODO: add a field for device
        ListElement {
            name: "thing"
            device: null
        }
    }

    function filterDevices(filterText) {
        var devices = adapter.devices.values
        // var filterText = search.text.toLowerCase()
        filteredDevices.clear()

        for (var rep = 0; rep < 9; rep++) {
            for (var i = 0; i < devices.length; i++) {
                var item = devices[i]
                if (item.name.toLowerCase().indexOf(filterText) !== -1) {
                    filteredDevices.append(item)
                }
            }
        }
    }
    onVisibleChanged: filterDevices("")

    Rectangle{
        id: searchBar
        anchors {
            left: parent.left
            right: parent.right
        }
        implicitHeight:25
        color: Theme.mainBackgroundColor
        z: 99
        TextField {
            anchors {
                // top: parent.top
                left: parent.left
                right: parent.right
                margins: 12
            }

            placeholderText: "Search"
            color: Theme.mainTextColor
            font.family: Theme.textFont
            font.pixelSize: 14
            // focus: true

            background: Rectangle {
                color: Qt.rgba(1, 1, 1, 0.37)
                radius: 6
            }

            onTextChanged: filterDevices(this.text.toLowerCase())
        }
    }

    ListView {
        id: deviceList
        anchors {
            // fill: parent
            top: searchBar.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        model: filteredDevices
        delegate: Entry {}

        // headerPositioning: ListView.OverlayHeader
        // header: searchHeader
    }
}
