import QtQuick
import Quickshell
import Quickshell.Widgets
import qs.Themes

Item {
  id: root

  property DesktopEntry modelData
  // iconSource - The path of the application's icon, or "" if it has none or it isn't in the icon theme
  readonly property string iconSource: modelData?.icon ? Quickshell.iconPath(modelData.icon, true) : ""
  readonly property bool favourite: modelData !== null && Favourites.isFavourite(modelData.id)

  implicitHeight: Math.max(iconSlot.height, applicationName.implicitHeight)

  // Always the same size, so every name lines up whether or not the application has an icon
  Item {
    id: iconSlot
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    width: 24
    height: 24

    IconImage {
      id: applicationIcon
      anchors.fill: parent
      visible: root.iconSource !== "" && status === Image.Ready
      source: root.iconSource
      asynchronous: true
    }

    Text {
      id: placeholderIcon
      anchors.centerIn: parent
      visible: !applicationIcon.visible
      color: Theme.mutedTextColor
      font.family: Theme.iconFont
      font.pixelSize: 20
      text: Icons.get("placeholder")
    }
  }

  Text {
    id: applicationName
    anchors.left: iconSlot.right
    anchors.right: favouriteButton.left
    anchors.leftMargin: 8
    anchors.rightMargin: 8
    anchors.verticalCenter: parent.verticalCenter
    elide: Text.ElideRight
    color: Theme.textColor
    font.family: Theme.textFont
    font.pixelSize: 14
    text: root.modelData?.name ?? ""
  }

  MouseArea {
    id: favouriteButton
    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter
    width: 24
    height: 24
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    onClicked: {
      if (root.modelData !== null) Favourites.toggle(root.modelData.id)
    }

    Text {
      id: favouriteIcon
      anchors.centerIn: parent
      color: root.favourite || favouriteButton.containsMouse ? Theme.accentColor : Theme.mutedTextColor
      font.family: Theme.iconFont
      font.pixelSize: 16
      text: Icons.get(root.favourite ? "favourite" : "notFavourite")
    }
  }
}
