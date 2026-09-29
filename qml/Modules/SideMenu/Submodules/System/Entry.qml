import QtQuick
import qs.Themes

Item {
  id: root

  // process - The process shown, see SystemStats.processes
  property var process
  // program - The top process of the program it's part of, which the kill button kills, null if it can't be killed
  property var program: null
  // cpuWidth, memoryWidth - Widths of the CPU and RAM columns, shared with the headings
  property real cpuWidth: 56
  property real memoryWidth: 64

  // killed - Emitted when the kill button is clicked
  signal killed()

  // formatMemory - Bytes as a short size, e.g. "812M" or "1.4G"
  function formatMemory(bytes: real): string {
    const mebibytes = bytes / 1048576
    if (mebibytes < 1024) return Math.round(mebibytes) + "M"
    return (mebibytes / 1024).toFixed(1) + "G"
  }

  implicitHeight: Math.max(names.implicitHeight, killButton.implicitHeight) + 8

  Rectangle {
    id: background
    anchors.fill: parent
    radius: 4
    color: Theme.surfaceColor
    visible: hover.hovered
  }

  HoverHandler {
    id: hover
  }

  Column {
    id: names
    anchors.left: parent.left
    anchors.right: cpu.left
    anchors.leftMargin: 6
    anchors.rightMargin: 8
    anchors.verticalCenter: parent.verticalCenter

    Text {
      id: processName
      width: parent.width
      elide: Text.ElideRight
      textFormat: Text.PlainText
      color: Theme.textColor
      font.family: Theme.textFont
      font.pixelSize: 13
      text: root.process?.name ?? ""
    }

    Text {
      id: programName
      width: parent.width
      visible: root.program !== null && root.program.pid !== root.process?.pid
      elide: Text.ElideRight
      textFormat: Text.PlainText
      color: Theme.mutedTextColor
      font.family: Theme.textFont
      font.pixelSize: 11
      text: "in " + (root.program?.name ?? "")
    }
  }

  Text {
    id: cpu
    anchors.right: memory.left
    anchors.verticalCenter: parent.verticalCenter
    width: root.cpuWidth
    horizontalAlignment: Text.AlignRight
    color: Theme.textColor
    font.family: Theme.textFont
    font.pixelSize: 13
    text: (root.process?.cpu ?? 0).toFixed(1) + "%"
  }

  Text {
    id: memory
    anchors.right: killButton.left
    anchors.verticalCenter: parent.verticalCenter
    width: root.memoryWidth
    horizontalAlignment: Text.AlignRight
    color: Theme.textColor
    font.family: Theme.textFont
    font.pixelSize: 13
    text: root.formatMemory(root.process?.memory ?? 0)
  }

  MouseArea {
    id: killButton
    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter
    implicitWidth: 28
    implicitHeight: 24
    enabled: root.program !== null
    hoverEnabled: true
    cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
    onClicked: root.killed()

    Text {
      id: killIcon
      anchors.centerIn: parent
      visible: killButton.enabled
      color: killButton.containsMouse ? Theme.dangerColor : Theme.mutedTextColor
      font.family: Theme.iconFont
      font.pixelSize: 16
      text: Icons.get("kill")
    }
  }
}
