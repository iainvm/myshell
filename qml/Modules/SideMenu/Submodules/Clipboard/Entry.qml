import QtQuick
import qs.Themes

Item {
  id: root

  // modelData - The clipboard entry shown, see ClipboardHistory.entries
  property var modelData
  readonly property bool image: modelData?.image ?? false

  implicitHeight: Math.max(removeButton.height, root.image ? imagePreview.height : preview.implicitHeight) + 12

  Text {
    id: preview
    anchors.left: parent.left
    anchors.right: removeButton.left
    anchors.rightMargin: 8
    anchors.verticalCenter: parent.verticalCenter
    visible: !root.image
    wrapMode: Text.Wrap
    maximumLineCount: 3
    elide: Text.ElideRight
    textFormat: Text.PlainText
    color: Theme.textColor
    font.family: Theme.textFont
    font.pixelSize: 14
    text: root.modelData?.text ?? ""
  }

  Image {
    id: imagePreview
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    visible: root.image
    width: Math.min(parent.width - removeButton.width - imageDetails.implicitWidth - 24, 160)
    height: root.image ? Math.min(80, root.modelData.height) : 0
    horizontalAlignment: Image.AlignLeft
    fillMode: Image.PreserveAspectFit
    sourceSize.height: 160
    asynchronous: true
    source: root.image ? "file://" + ClipboardHistory.imagePath(root.modelData) : ""
  }

  Text {
    id: imageDetails
    anchors.left: imagePreview.left
    anchors.leftMargin: imagePreview.paintedWidth + 8
    anchors.verticalCenter: parent.verticalCenter
    visible: root.image
    color: Theme.mutedTextColor
    font.family: Theme.textFont
    font.pixelSize: 12
    text: root.image ? root.modelData.width + "x" + root.modelData.height + "\n" + root.modelData.format + ", " + root.modelData.bytes : ""
  }

  MouseArea {
    id: removeButton
    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter
    width: 24
    height: 24
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    onClicked: {
      if (root.modelData) ClipboardHistory.remove(root.modelData)
    }

    Text {
      id: removeIcon
      anchors.centerIn: parent
      color: removeButton.containsMouse ? Theme.accentColor : Theme.mutedTextColor
      font.family: Theme.iconFont
      font.pixelSize: 16
      text: Icons.get("remove")
    }
  }
}
