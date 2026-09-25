import QtQuick
import qs.Themes

Column {
  id: root

  // model - The items to search through, shown in the order given
  property var model: []
  // textOf - Returns the text of an item that the search is matched against
  property var textOf: item => item?.name ?? String(item)
  // delegate - The content of each row, it must declare `property var modelData` (or a stricter type) to receive its item
  property Component delegate
  // placeholderText - Shown in the search box while it's empty
  property string placeholderText: "Search"
  // emptyText - Shown when model has no items
  property string emptyText: "Nothing to show"
  // noMatchText - Shown when model has items but none match the search
  property string noMatchText: "No matches"
  // focusOnLoad - If the search box takes keyboard focus when created
  property bool focusOnLoad: true

  // query - The lowercased search text
  readonly property string query: searchInput.text.toLowerCase()
  // results - The items of model matching the search
  readonly property var results: model.filter(item => String(textOf(item)).toLowerCase().includes(query))

  // activated - Emitted when a row is clicked, or for the top result when Enter is pressed in the search box
  signal activated(var item)

  function focusSearch() {
    searchInput.forceActiveFocus()
  }

  spacing: 8

  Component.onCompleted: {
    if (root.focusOnLoad) root.focusSearch()
  }

  Rectangle {
    id: searchBox
    width: parent.width
    implicitHeight: 36
    radius: 6
    color: Theme.surfaceColor

    Text {
      id: searchIcon
      anchors.left: parent.left
      anchors.leftMargin: 10
      anchors.verticalCenter: parent.verticalCenter
      color: Theme.mutedTextColor
      font.family: Theme.iconFont
      font.pixelSize: 16
      text: Icons.get("search")
    }

    TextInput {
      id: searchInput
      anchors.left: searchIcon.right
      anchors.right: parent.right
      anchors.leftMargin: 8
      anchors.rightMargin: 10
      anchors.verticalCenter: parent.verticalCenter
      color: Theme.textColor
      selectionColor: Theme.accentColor
      font.family: Theme.textFont
      font.pixelSize: 14
      clip: true
      onAccepted: {
        if (root.results.length > 0) root.activated(root.results[0])
      }

      Text {
        id: placeholder
        anchors.fill: parent
        visible: searchInput.text === ""
        color: Theme.mutedTextColor
        font: searchInput.font
        text: root.placeholderText
      }
    }
  }

  Text {
    id: message
    width: parent.width
    visible: root.results.length === 0
    horizontalAlignment: Text.AlignHCenter
    topPadding: 8
    color: Theme.mutedTextColor
    font.family: Theme.textFont
    font.pixelSize: 14
    text: root.query !== "" && root.model.length > 0 ? root.noMatchText : root.emptyText
  }

  Repeater {
    id: rows
    model: root.results

    delegate: MouseArea {
      id: row

      required property var modelData

      width: root.width
      implicitHeight: Math.max(36, content.implicitHeight)
      hoverEnabled: true
      cursorShape: Qt.PointingHandCursor
      onClicked: root.activated(modelData)

      Rectangle {
        id: rowBackground
        anchors.fill: parent
        radius: 6
        color: Theme.surfaceColor
        visible: row.containsMouse
      }

      Loader {
        id: content
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        sourceComponent: root.delegate
        onLoaded: item.modelData = Qt.binding(() => row.modelData)
      }
    }
  }
}
