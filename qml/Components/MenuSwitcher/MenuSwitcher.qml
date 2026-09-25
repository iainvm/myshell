import QtQuick
import qs.Themes

Item {
  id: root

  // menus - The menus that can be switched between
  property list<Menu> menus
  // currentIndex - The index in menus of the menu currently shown
  property int currentIndex: 0
  // open - If the drop down list of menus is currently open
  property bool open: false
  // active - If the current menu is instantiated, set false to destroy it so it's rebuilt when set back to true
  property bool active: true

  readonly property Menu currentMenu: menus.length > 0 ? menus[Math.min(currentIndex, menus.length - 1)] : null

  // show - Switches to the menu with the given name (case-insensitive) and closes the list, returns false if there's no such menu
  function show(name: string): bool {
    const index = Array.from(root.menus).findIndex(menu => menu.name.toLowerCase() === name.toLowerCase())
    if (index === -1) {
      console.warn("MenuSwitcher: no menu named", name)
      return false
    }
    root.currentIndex = index
    root.open = false
    return true
  }

  onActiveChanged: open = false

  Keys.onEscapePressed: event => {
    if (root.open) root.open = false
    else event.accepted = false
  }

  MouseArea {
    id: button
    width: parent.width
    implicitHeight: 36
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    onClicked: root.open = !root.open

    Rectangle {
      id: buttonBackground
      anchors.fill: parent
      radius: 6
      color: Theme.surfaceColor
      border.width: 1
      border.color: root.open || button.containsMouse ? Theme.accentColor : Theme.surfaceColor
    }

    Row {
      id: buttonLabel
      anchors.left: parent.left
      anchors.leftMargin: 10
      anchors.verticalCenter: parent.verticalCenter
      spacing: 8

      Text {
        id: buttonIcon
        anchors.verticalCenter: parent.verticalCenter
        color: Theme.accentColor
        font.family: Theme.iconFont
        font.pixelSize: 16
        text: root.currentMenu?.icon ?? ""
      }

      Text {
        id: buttonName
        anchors.verticalCenter: parent.verticalCenter
        color: Theme.textColor
        font.family: Theme.textFont
        font.pixelSize: 14
        text: root.currentMenu?.name ?? ""
      }
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
    implicitHeight: listItems.implicitHeight + 8
    z: 1
    visible: root.open
    radius: 6
    color: Theme.surfaceColor
    border.width: 1
    border.color: Theme.accentColor

    Column {
      id: listItems
      anchors.fill: parent
      anchors.margins: 4

      Repeater {
        id: listRepeater
        model: root.menus

        delegate: MouseArea {
          id: listItem

          required property Menu modelData
          required property int index
          readonly property bool selected: root.currentIndex === index

          width: listItems.width
          implicitHeight: 32
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
          onClicked: {
            root.currentIndex = index
            root.open = false
          }

          Rectangle {
            id: listItemBackground
            anchors.fill: parent
            radius: 4
            color: Theme.backgroundColor
            visible: listItem.containsMouse
          }

          Row {
            id: listItemLabel
            anchors.left: parent.left
            anchors.leftMargin: 6
            anchors.verticalCenter: parent.verticalCenter
            spacing: 8

            Text {
              id: listItemIcon
              anchors.verticalCenter: parent.verticalCenter
              color: listItem.selected ? Theme.accentColor : Theme.textColor
              font.family: Theme.iconFont
              font.pixelSize: 16
              text: listItem.modelData.icon
            }

            Text {
              id: listItemName
              anchors.verticalCenter: parent.verticalCenter
              color: listItem.selected ? Theme.accentColor : Theme.textColor
              font.family: Theme.textFont
              font.pixelSize: 14
              text: listItem.modelData.name
            }
          }
        }
      }
    }
  }

  Flickable {
    id: scroller
    anchors.top: button.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    anchors.topMargin: 12
    clip: true
    contentWidth: width
    contentHeight: page.height
    boundsBehavior: Flickable.StopAtBounds

    // Pages are at least as tall as the scroll area, so a page with its own scrolling (e.g. SearchList) can fill it, while taller pages scroll here
    Loader {
      id: page
      width: scroller.width
      height: Math.max(scroller.height, item?.implicitHeight ?? 0)
      active: root.active && root.currentMenu !== null
      sourceComponent: root.currentMenu?.component ?? null
    }
  }
}
