import QtQuick
import Quickshell
import qs.Themes

Column {
  id: root

  // now - The current time in milliseconds, used for the time since each notification was received
  readonly property real now: clock.date.getTime()

  spacing: 8

  SystemClock {
    id: clock
    precision: SystemClock.Seconds
  }

  Text {
    id: emptyMessage
    width: parent.width
    visible: NotificationHistory.entries.length === 0
    horizontalAlignment: Text.AlignHCenter
    topPadding: 8
    color: Theme.mutedTextColor
    font.family: Theme.textFont
    font.pixelSize: 14
    text: "No notifications"
  }

  Repeater {
    id: entries
    model: NotificationHistory.entries

    delegate: Entry {
      required property var modelData

      width: root.width
      notification: modelData
      now: root.now
    }
  }
}
