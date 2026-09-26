import QtQuick
import Quickshell
import Quickshell.Networking
import qs.Components.SearchList
import qs.Components.PromptPopup

SearchList {
  id: root

  readonly property bool available: Networking.backend !== NetworkBackendType.None
  readonly property var devices: Array.from(Networking.devices.values)
  readonly property var wifiDevices: devices.filter(device => device.type === DeviceType.Wifi)

  // wiredNetworks - The networks of connected LAN devices, shown above the Wi-Fi networks
  readonly property var wiredNetworks: devices
    .filter(device => device.type === DeviceType.Wired && device.connected && device.network !== null)
    .map(device => device.network)

  // wifiNetworks - Every named Wi-Fi network in range, connected first, then saved ones, then by signal strength
  readonly property var wifiNetworks: {
    if (!Networking.wifiEnabled) return []
    return wifiDevices
      .reduce((networks, device) => networks.concat(Array.from(device.networks.values)), [])
      .filter(network => network.name !== "")
      .sort((first, second) => (second.connected - first.connected)
        || (second.known - first.known)
        || (second.signalStrength - first.signalStrength)
        || first.name.localeCompare(second.name))
  }

  // pendingNetwork - The Wi-Fi network being connected to, kept so a password can be asked for if it's needed
  property WifiNetwork pendingNetwork: null
  // passwordAttempted - If a password has been given for pendingNetwork, so a second request for one means it was wrong
  property bool passwordAttempted: false

  // usesPassword - If the network can be connected to by just giving it a password
  function usesPassword(network: WifiNetwork): bool {
    return network.security === WifiSecurityType.WpaPsk
      || network.security === WifiSecurityType.Wpa2Psk
      || network.security === WifiSecurityType.Sae
  }

  function select(network: Network) {
    if (network.device.type !== DeviceType.Wifi) return
    if (network.connected) {
      network.disconnect()
      return
    }
    root.pendingNetwork = network
    root.passwordAttempted = false
    network.connect()
  }

  function setScanning(enabled: bool) {
    root.wifiDevices.forEach(device => device.scannerEnabled = enabled)
  }

  // The LAN entry is only shown while not searching
  model: (query === "" ? wiredNetworks : []).concat(wifiNetworks)

  textOf: network => network.name
  placeholderText: "Search Wi-Fi networks"
  emptyText: {
    if (!available) return "NetworkManager isn't running"
    if (!Networking.wifiEnabled) return "Wi-Fi is off"
    return "No networks found"
  }
  noMatchText: "No matching networks"
  onActivated: network => root.select(network)

  delegate: Entry {}

  // Scan for networks only while the page is open
  onWifiDevicesChanged: setScanning(true)
  Component.onCompleted: setScanning(true)
  Component.onDestruction: setScanning(false)

  // connect() returns before NetworkManager finishes, so a missing or wrong password is only known once the connection fails
  Connections {
    id: connectionWatcher
    target: root.pendingNetwork

    function onConnectionFailed(reason) {
      const network = root.pendingNetwork
      if (network === null) return
      if (reason === ConnectionFailReason.NoSecrets && root.usesPassword(network)) {
        passwordPrompt.message = root.passwordAttempted ? "Wrong password, try again" : ""
        passwordPrompt.open()
        return
      }
      root.pendingNetwork = null
      console.warn("Failed to connect to", network.name + ":", ConnectionFailReason.toString(reason))
    }

    function onConnectedChanged() {
      if (root.pendingNetwork?.connected) root.pendingNetwork = null
    }
  }

  PromptPopup {
    id: passwordPrompt
    anchors.fill: parent
    title: "Connect to " + (root.pendingNetwork?.name ?? "")
    placeholderText: "Password"
    password: true
    acceptText: "Connect"
    onAccepted: text => {
      root.passwordAttempted = true
      root.pendingNetwork?.connectWithPsk(text)
      root.focusSearch()
    }
    onCancelled: {
      root.pendingNetwork = null
      root.focusSearch()
    }
  }
}
