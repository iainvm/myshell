import QtQuick
import Quickshell.Services.Pipewire
import qs.Themes
import qs.Components.Slider
import qs.Components.DropDown as Components

Column {
  id: root

  // title - The heading shown above the device picker, e.g. "Output"
  property string title
  // kind - Picks the icons shown, "output" or "input"
  property string kind: "output"
  // nodes - The devices that can be picked
  property var nodes: []
  // node - The current default device, whose volume is shown
  property PwNode node: null

  readonly property bool controllable: (node?.audio ?? null) !== null
  readonly property bool muted: node?.audio?.muted ?? false
  readonly property real volume: node?.audio?.volume ?? 0

  // selected - Emitted when a device is picked to become the default
  signal selected(PwNode node)

  // nameOf - Gives the name shown for a device
  property var nameOf: device => device.name

  spacing: 8

  Text {
    id: heading
    color: Theme.mutedTextColor
    font.family: Theme.textFont
    font.pixelSize: 12
    text: root.title
  }

  Components.DropDown {
    id: picker
    width: root.width
    model: root.nodes
    currentItem: root.node
    textOf: device => root.nameOf(device)
    icon: Icons.get(root.kind)
    placeholderText: "No default device"
    emptyText: "No devices found"
    onActivated: device => root.selected(device)
  }

  Item {
    id: volumeRow
    width: root.width
    implicitHeight: Math.max(muteButton.implicitHeight, slider.implicitHeight, percentage.implicitHeight)

    MouseArea {
      id: muteButton
      anchors.left: parent.left
      anchors.verticalCenter: parent.verticalCenter
      implicitWidth: muteIcon.implicitWidth + 8
      implicitHeight: muteIcon.implicitHeight
      enabled: root.controllable
      hoverEnabled: true
      cursorShape: Qt.PointingHandCursor
      onClicked: root.node.audio.muted = !root.node.audio.muted

      Text {
        id: muteIcon
        anchors.centerIn: parent
        color: root.muted ? Theme.mutedTextColor : (muteButton.containsMouse ? Theme.accentColor : Theme.textColor)
        font.family: Theme.iconFont
        font.pixelSize: 18
        text: Icons.get(root.kind + (root.muted ? "Muted" : ""))
      }
    }

    Slider {
      id: slider
      anchors.left: muteButton.right
      anchors.right: percentage.left
      anchors.leftMargin: 8
      anchors.rightMargin: 8
      anchors.verticalCenter: parent.verticalCenter
      interactive: root.controllable
      value: root.volume
      opacity: interactive && !root.muted ? 1 : 0.5
      onMoved: value => {
        root.node.audio.volume = value
        if (root.muted) root.node.audio.muted = false
      }
    }

    Text {
      id: percentage
      anchors.right: parent.right
      anchors.verticalCenter: parent.verticalCenter
      width: 40
      horizontalAlignment: Text.AlignRight
      color: root.muted ? Theme.mutedTextColor : Theme.textColor
      font.family: Theme.textFont
      font.pixelSize: 13
      text: Math.round(root.volume * 100) + "%"
    }
  }
}
