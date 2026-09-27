import QtQuick
import Quickshell.Widgets
import qs.Settings
import qs.Themes

Rectangle {
  id: root

  // notification - The history entry shown, see NotificationHistory.entries
  property var notification
  // now - The current time in milliseconds, the time since is shown relative to it
  property real now: Date.now()

  readonly property bool hovered: hover.hovered
  readonly property string iconSource: notification?.appIcon ?? ""

  // since - How long ago the time (in milliseconds) was, relative to now, e.g. "5m ago"
  function since(time: real): string {
    const seconds = Math.max(0, Math.floor((root.now - time) / 1000))
    if (seconds < 60) return "now"
    const minutes = Math.floor(seconds / 60)
    if (minutes < 60) return minutes + "m ago"
    const hours = Math.floor(minutes / 60)
    if (hours < 24) return hours + "h ago"
    return Math.floor(hours / 24) + "d ago"
  }

  implicitHeight: content.implicitHeight + content.anchors.margins * 2
  radius: 6
  color: "transparent"
  border.width: 1
  border.color: root.hovered ? Theme.accentColor : Theme.surfaceColor

  HoverHandler {
    id: hover
  }

  Column {
    id: content
    anchors.fill: parent
    anchors.margins: 10
    spacing: 6

    Item {
      id: header
      width: parent.width
      implicitHeight: Math.max(iconSlot.height, appName.implicitHeight, time.implicitHeight)

      Item {
        id: iconSlot
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        width: 16
        height: 16

        IconImage {
          id: appIcon
          anchors.fill: parent
          visible: root.iconSource !== "" && status === Image.Ready
          source: root.iconSource
          asynchronous: true
        }

        Text {
          id: placeholderIcon
          anchors.centerIn: parent
          visible: !appIcon.visible
          color: Theme.mutedTextColor
          font.family: Theme.iconFont
          font.pixelSize: 14
          text: Icons.get("placeholder")
        }
      }

      Text {
        id: appName
        anchors.left: iconSlot.right
        anchors.right: time.left
        anchors.leftMargin: 6
        anchors.rightMargin: 8
        anchors.verticalCenter: parent.verticalCenter
        elide: Text.ElideRight
        textFormat: Text.PlainText
        color: Theme.mutedTextColor
        font.family: Theme.textFont
        font.pixelSize: 12
        text: root.notification?.appName || "Unknown"
      }

      Text {
        id: time
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        color: Theme.mutedTextColor
        font.family: Theme.textFont
        font.pixelSize: 12
        text: {
          const received = root.notification?.time ?? 0
          return root.hovered
            ? Qt.formatDateTime(new Date(received), Settings.notifications.timestampFormat)
            : root.since(received)
        }
      }
    }

    Text {
      id: summary
      width: parent.width
      visible: text !== ""
      wrapMode: Text.Wrap
      textFormat: Text.PlainText
      color: Theme.textColor
      font.family: Theme.textFont
      font.pixelSize: 14
      font.bold: true
      text: root.notification?.summary ?? ""
    }

    Text {
      id: body
      width: parent.width
      visible: text !== ""
      wrapMode: Text.Wrap
      maximumLineCount: root.hovered ? 1000 : 4
      elide: Text.ElideRight
      textFormat: Text.PlainText
      color: Theme.textColor
      font.family: Theme.textFont
      font.pixelSize: 13
      text: root.notification?.body ?? ""
    }
  }
}
