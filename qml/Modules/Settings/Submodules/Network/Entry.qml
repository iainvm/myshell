import QtQuick
import Quickshell.Networking
import qs.Themes

Row {
  id: root

  property Network modelData
  readonly property bool wired: modelData?.device?.type === DeviceType.Wired
  readonly property bool locked: !wired && modelData !== null
    && modelData.security !== WifiSecurityType.Open
    && modelData.security !== WifiSecurityType.Owe
  readonly property int signalLevel: Math.max(0, Math.min(4, Math.round((modelData?.signalStrength ?? 0) * 4)))

  spacing: 8
  opacity: (modelData?.stateChanging ?? false) ? 0.5 : 1

  Text {
    id: networkIcon
    anchors.verticalCenter: parent.verticalCenter
    color: (root.modelData?.connected ?? false) ? Theme.accentColor : Theme.textColor
    font.family: Theme.iconFont
    font.pixelSize: 16
    text: Icons.get(root.wired ? "wired" : "signal" + root.signalLevel + (root.locked ? "Locked" : ""))
  }

  Text {
    id: networkName
    anchors.verticalCenter: parent.verticalCenter
    color: Theme.textColor
    font.family: Theme.textFont
    font.pixelSize: 14
    text: root.wired ? "LAN" : (root.modelData?.name ?? "")
  }

  Text {
    id: wiredName
    anchors.verticalCenter: parent.verticalCenter
    visible: root.wired && text !== ""
    color: Theme.mutedTextColor
    font.family: Theme.textFont
    font.pixelSize: 14
    text: root.modelData?.name ?? ""
  }

  Text {
    id: connectedIcon
    anchors.verticalCenter: parent.verticalCenter
    visible: root.modelData?.connected ?? false
    color: Theme.accentColor
    font.family: Theme.iconFont
    font.pixelSize: 16
    text: Icons.get("connected")
  }

  Text {
    id: savedIcon
    anchors.verticalCenter: parent.verticalCenter
    visible: !root.wired && (root.modelData?.known ?? false)
    color: Theme.mutedTextColor
    font.family: Theme.iconFont
    font.pixelSize: 16
    text: Icons.get("saved")
  }
}
