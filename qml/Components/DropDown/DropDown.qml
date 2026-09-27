import QtQuick
import qs.Themes

Item {
  id: root

  // model - The items that can be picked from, a JS array
  property var model: []
  // currentItem - The picked item, shown on the button and highlighted in the list
  property var currentItem: null
  // textOf - Gives the text shown for an item
  property var textOf: item => String(item)
  // icon - The Nerd Font glyph shown on the left of the button
  property string icon: ""
  // placeholderText - Shown on the button when nothing is picked
  property string placeholderText: ""
  // emptyText - Shown in the list when model is empty
  property string emptyText: "Nothing to pick"
  // open - If the list of items is currently open
  property bool open: false

  // activated - Emitted when an item is picked from the list
  signal activated(var item)

  implicitHeight: button.height + (open ? list.anchors.topMargin + list.height : 0)

  Keys.onEscapePressed: event => {
    if (root.open) root.open = false
    else event.accepted = false
  }

  MouseArea {
    id: button
    width: parent.width
    height: 36
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    onClicked: {
      root.forceActiveFocus()
      root.open = !root.open
    }

    Rectangle {
      id: buttonBackground
      anchors.fill: parent
      radius: 6
      color: Theme.surfaceColor
      border.width: 1
      border.color: root.open || button.containsMouse ? Theme.accentColor : Theme.surfaceColor
    }

    Text {
      id: buttonIcon
      anchors.left: parent.left
      anchors.leftMargin: 10
      anchors.verticalCenter: parent.verticalCenter
      visible: text !== ""
      color: Theme.accentColor
      font.family: Theme.iconFont
      font.pixelSize: 16
      text: root.icon
    }

    Text {
      id: buttonText
      anchors.left: buttonIcon.visible ? buttonIcon.right : parent.left
      anchors.leftMargin: buttonIcon.visible ? 8 : 10
      anchors.right: buttonChevron.left
      anchors.rightMargin: 8
      anchors.verticalCenter: parent.verticalCenter
      elide: Text.ElideRight
      textFormat: Text.PlainText
      color: root.currentItem === null ? Theme.mutedTextColor : Theme.textColor
      font.family: Theme.textFont
      font.pixelSize: 14
      text: root.currentItem === null ? root.placeholderText : root.textOf(root.currentItem)
    }

    Text {
      id: buttonChevron
      anchors.right: parent.right
      anchors.rightMargin: 10
      anchors.verticalCenter: parent.verticalCenter
      color: Theme.mutedTextColor
      font.family: Theme.iconFont
      font.pixelSize: 16
      text: Icons.get(root.open ? "open" : "closed")
    }
  }

  Rectangle {
    id: list
    anchors.top: button.bottom
    anchors.topMargin: 4
    width: parent.width
    height: listItems.implicitHeight + 8
    visible: root.open
    radius: 6
    color: Theme.surfaceColor
    border.width: 1
    border.color: Theme.accentColor

    Column {
      id: listItems
      anchors.fill: parent
      anchors.margins: 4

      Text {
        id: emptyMessage
        width: parent.width
        visible: root.model.length === 0
        horizontalAlignment: Text.AlignHCenter
        topPadding: 6
        bottomPadding: 6
        color: Theme.mutedTextColor
        font.family: Theme.textFont
        font.pixelSize: 14
        text: root.emptyText
      }

      Repeater {
        id: listRepeater
        model: root.model

        delegate: MouseArea {
          id: listItem

          required property var modelData
          readonly property bool selected: modelData === root.currentItem

          width: listItems.width
          implicitHeight: 32
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
          onClicked: {
            root.open = false
            root.activated(modelData)
          }

          Rectangle {
            id: listItemBackground
            anchors.fill: parent
            radius: 4
            color: Theme.backgroundColor
            visible: listItem.containsMouse
          }

          Text {
            id: listItemText
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 6
            anchors.rightMargin: 6
            anchors.verticalCenter: parent.verticalCenter
            elide: Text.ElideRight
            textFormat: Text.PlainText
            color: listItem.selected ? Theme.accentColor : Theme.textColor
            font.family: Theme.textFont
            font.pixelSize: 14
            text: root.textOf(listItem.modelData)
          }
        }
      }
    }
  }
}
