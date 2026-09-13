import Quickshell
import Quickshell.Bluetooth
import Quickshell.Hyprland
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.Theme
import qs.Settings

MouseArea {
    id: root

    implicitWidth: 25
    height: parent.height

    // Battery Info
    readonly property BluetoothAdapter bluetooth: Bluetooth.defaultAdapter

    // Icons
    readonly property string iconOn: "󰂯"
    readonly property string iconOff: "󰂲"
    readonly property string iconConnected: "󰂱"

    property bool panelVisible: false
    onClicked: {
        panelVisible = !panelVisible
    }

    Text {
        id: iconText

        anchors.centerIn: parent
        anchors.verticalCenter: parent.verticalCenter
        color: Theme.mainTextColor
        font.family: Theme.iconFont

        text: {
            if (root.bluetooth.enabled) return root.iconOn
            if (root.bluetooth.devices.values.length > 0) return root.iconConnected
            return root.iconOff
        }

        font.pixelSize: 18
    }

    // Source data - unfiltered
    ListModel {
        id: deviceSourceModel
        
        ListElement { name: "Sony WH-1000XM5"; paired: true; connected: true }
        ListElement { name: "AirPods Pro"; paired: true; connected: false }
        ListElement { name: "Logitech MX Master 3"; paired: true; connected: false }
        ListElement { name: "Galaxy Buds2"; paired: false; connected: false }
        ListElement { name: "SteelSeries Arctis 7"; paired: false; connected: false }
    }

    // Filtered view
    ListModel {
        id: deviceFilteredModel
    }

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
        implicitHeight: 400

        onVisibleChanged: {
            if (visible) {
                // Initialize with full list when panel opens
                var filterText = ""
                deviceFilteredModel.clear()
                
                for (var i = 0; i < deviceSourceModel.count; i++) {
                    var item = deviceSourceModel.get(i)
                    deviceFilteredModel.append(item)
                }
            }
        }

        ColumnLayout {
            id: contentColumn
            anchors.fill: parent
            anchors.margins: 12
            spacing: 8

            TextField {
                id: search
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignTop
                placeholderText: "Search"
                color: Theme.mainTextColor
                font.family: Theme.textFont
                font.pixelSize: 14

                background: Rectangle {
                    color: Qt.rgba(1, 1, 1, 0.1)
                    radius: 6
                }

                onTextChanged: {
                    var filterText = search.text.toLowerCase()
                    deviceFilteredModel.clear()
                    
                    for (var i = 0; i < deviceSourceModel.count; i++) {
                        var item = deviceSourceModel.get(i)
                        if (item.name.toLowerCase().indexOf(filterText) !== -1) {
                            deviceFilteredModel.append(item)
                        }
                    }
                }
            }

            ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true

                ListView {
                    id: deviceList
                    model: deviceFilteredModel

                    delegate: ItemDelegate {
                        width: deviceList.width
                        height: 50

                        RowLayout {
                            anchors.centerIn: parent
                            anchors.left: parent.left
                            anchors.leftMargin: 8
                            anchors.right: parent.right
                            anchors.rightMargin: 8
                            spacing: 10

                            Text {
                                text: name
                                color: Theme.mainTextColor
                                font.family: Theme.textFont
                                font.pixelSize: 14
                                Layout.fillWidth: true
                                elide: Text.ElideRight
                            }

                            Text {
                                text: connected ? "󰂱" : (paired ? "󰂯" : "󰂲")
                                font.family: Theme.iconFont
                                color: Theme.mainTextColor
                                font.pixelSize: 14
                                opacity: 0.7
                            }
                        }

                        onClicked: {
                            console.log("Clicked on:", name)
                        }
                    }

                    ScrollBar.vertical: ScrollBar {
                        active: true
                        policy: ScrollBar.AsNeeded
                    }
                }
            }
        }
    }
}
