import QtQuick
import qs.Themes

MouseArea {
  id: root

  // name - The label under the icon, e.g. "Power Off"
  property string name
  // icon - The Nerd Font glyph shown
  property string icon
  // shortcut - The key that also runs the button's action while the System menu is open, shown in the corner
  property string shortcut

  implicitHeight: 64
  hoverEnabled: true
  cursorShape: Qt.PointingHandCursor

  Rectangle {
    id: background
    anchors.fill: parent
    radius: 6
    color: Theme.surfaceColor
    border.width: 1
    border.color: root.containsMouse ? Theme.accentColor : Theme.surfaceColor
  }

  Text {
    id: shortcutHint
    anchors.top: parent.top
    anchors.right: parent.right
    anchors.margins: 4
    color: Theme.mutedTextColor
    font.family: Theme.textFont
    font.pixelSize: 10
    text: root.shortcut
  }

  Column {
    id: label
    anchors.centerIn: parent
    spacing: 4

    Text {
      id: iconText
      anchors.horizontalCenter: parent.horizontalCenter
      color: root.containsMouse ? Theme.accentColor : Theme.textColor
      font.family: Theme.iconFont
      font.pixelSize: 22
      text: root.icon
    }

    Text {
      id: nameText
      anchors.horizontalCenter: parent.horizontalCenter
      color: Theme.textColor
      font.family: Theme.textFont
      font.pixelSize: 12
      text: root.name
    }
  }
}
