import QtQuick
import Quickshell
import Quickshell.Bluetooth
import qs.Components.SearchList

SearchList {
    id: root

    readonly property BluetoothAdapter adapter: Bluetooth.defaultAdapter
    readonly property bool adapterOn: adapter !== null && adapter.enabled

    function toggle(device: BluetoothDevice) {
        root.reconnectingDevice = null
        if (device.connected && !device.trusted && !device.batteryAvailable) {
            reconnect(device)
            return
        }
        if (device.connected) {
            device.disconnect()
            return
        }
        if (!device.connected) {
            device.connect()
            return
        }
    }

    model: {
        if (!adapterOn) return []
        return Bluetooth.devices.values
        .filter(device => device.paired)
        .sort((first, second) => first.name.localeCompare(second.name))
    }

    textOf: device => device.name
    placeholderText: "Search paired devices"
    emptyText: adapterOn ? "No paired devices" : "Bluetooth is off"
    noMatchText: "No matching devices"
    onActivated: device => root.toggle(device)

    delegate: Entry {}

    // reconnectingDevice - A device that has been asked to disconnect, and will be connected again once it has
    property BluetoothDevice reconnectingDevice: null
    function reconnect(device: BluetoothDevice) {
        root.reconnectingDevice = device
        device.disconnect()
    }

    // disconnect() and connect() return before BlueZ finishes, so wait for the disconnect to complete before connecting
    Connections {
        id: reconnectWatcher
        target: root.reconnectingDevice

        function onStateChanged() {
            const device = root.reconnectingDevice
            if (device ==  null) return
            if (device.state !== BluetoothDeviceState.Disconnected) return
            root.reconnectingDevice = null
            device.connect()
        }
    }
}
