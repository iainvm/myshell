import QtQuick
import Quickshell.Services.Pipewire
import qs.Themes

Item {
  id: root

  // audioDevices - Every audio device, leaving out the streams of apps playing or recording
  readonly property var audioDevices: Array.from(Pipewire.nodes.values)
    .filter(node => node.audio !== null && !node.isStream)
    .sort((first, second) => root.nameOf(first).localeCompare(root.nameOf(second)))
  readonly property var outputs: audioDevices.filter(node => node.isSink)
  readonly property var inputs: audioDevices.filter(node => !node.isSink)

  function nameOf(node: PwNode): string {
    return node.description || node.nickname || node.name
  }

  // Only the media player sets the height, so the page fills the scroll area and the devices scroll under the pinned player
  implicitHeight: media.implicitHeight

  // A device's volume and mute state are only known while it's tracked
  PwObjectTracker {
    id: tracker
    objects: [Pipewire.defaultAudioSink, Pipewire.defaultAudioSource]
  }

  MediaPlayer {
    id: media
    anchors.top: parent.top
    width: parent.width
  }

  Flickable {
    id: scroller
    anchors.top: media.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    anchors.topMargin: 12
    clip: true
    contentWidth: width
    contentHeight: devices.implicitHeight
    boundsBehavior: Flickable.StopAtBounds

    Column {
      id: devices
      width: scroller.width
      spacing: 16

      Text {
        id: unavailableMessage
        width: parent.width
        visible: !Pipewire.ready
        horizontalAlignment: Text.AlignHCenter
        topPadding: 8
        color: Theme.mutedTextColor
        font.family: Theme.textFont
        font.pixelSize: 14
        text: "PipeWire isn't connected"
      }

      Device {
        id: input
        width: parent.width
        visible: Pipewire.ready
        title: "Input"
        kind: "input"
        nodes: root.inputs
        nameOf: device => root.nameOf(device)
        node: Pipewire.defaultAudioSource
        onSelected: node => Pipewire.preferredDefaultAudioSource = node
      }

      Device {
        id: output
        width: parent.width
        visible: Pipewire.ready
        title: "Output"
        kind: "output"
        nodes: root.outputs
        nameOf: device => root.nameOf(device)
        node: Pipewire.defaultAudioSink
        onSelected: node => Pipewire.preferredDefaultAudioSink = node
      }
    }
  }
}
