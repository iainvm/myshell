import QtQuick
import qs.Themes

Item {
  id: root

  // model - The items to search through, shown in the order given
  property var model: []
  // textOf - Returns the text of an item that the search is matched against
  property var textOf: item => item?.name ?? String(item)
  // delegate - The content of each row, it must declare `property var modelData` (or a stricter type) to receive its item
  property Component delegate
  // spacing - The gap between the search box and the list, and between rows
  property int spacing: 8
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

  // currentIndex - The index in results of the selected row, moved with Up/Down and hover, reset to the top result when the results change
  readonly property int currentIndex: rows.currentIndex

  // activated - Emitted when a row is clicked, or for the selected row when Enter is pressed in the search box
  signal activated(var item)

  function focusSearch() {
    searchInput.forceActiveFocus()
  }

  function select(index) {
    if (root.results.length === 0) return
    rows.currentIndex = Math.max(0, Math.min(index, root.results.length - 1))
    rows.positionViewAtIndex(rows.currentIndex, ListView.Contain)
  }

  onResultsChanged: {
    rows.currentIndex = root.results.length > 0 ? 0 : -1
    rows.positionViewAtBeginning()
  }

  // Only the search box counts towards the implicit height, so a parent that sizes pages to their content (e.g. MenuSwitcher) gives the list the remaining space and it scrolls its own rows under the search box
  implicitHeight: searchBox.implicitHeight

  Component.onCompleted: {
    if (root.focusOnLoad) root.focusSearch()
  }

  Rectangle {
    id: searchBox
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
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
      Keys.onUpPressed: root.select(rows.currentIndex - 1)
      Keys.onDownPressed: root.select(rows.currentIndex + 1)
      onAccepted: {
        if (rows.currentIndex >= 0 && rows.currentIndex < root.results.length) root.activated(root.results[rows.currentIndex])
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
    anchors.top: searchBox.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.topMargin: root.spacing
    visible: root.results.length === 0
    horizontalAlignment: Text.AlignHCenter
    topPadding: 8
    color: Theme.mutedTextColor
    font.family: Theme.textFont
    font.pixelSize: 14
    text: root.query !== "" && root.model.length > 0 ? root.noMatchText : root.emptyText
  }

  ListView {
    id: rows
    anchors.top: searchBox.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    anchors.topMargin: root.spacing
    clip: true
    spacing: root.spacing
    boundsBehavior: Flickable.StopAtBounds
    model: root.results

    delegate: MouseArea {
      id: row

      required property var modelData
      required property int index

      width: rows.width
      implicitHeight: Math.max(36, content.implicitHeight)
      hoverEnabled: true
      cursorShape: Qt.PointingHandCursor
      onClicked: root.activated(modelData)
      onPositionChanged: rows.currentIndex = index

      Rectangle {
        id: rowBackground
        anchors.fill: parent
        radius: 6
        color: Theme.surfaceColor
        visible: row.ListView.isCurrentItem
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
