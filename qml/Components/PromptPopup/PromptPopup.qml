import QtQuick
import qs.Themes

Item {
  id: root

  // title - The heading of the popup
  property string title: ""
  // message - Text shown under the title, e.g. why the input is needed or what went wrong last time
  property string message: ""
  // placeholderText - Shown in the input while it's empty
  property string placeholderText: ""
  // password - If the input is masked
  property bool password: false
  // acceptText - The label of the button that accepts the input
  property string acceptText: "OK"
  // cancelText - The label of the button that closes the popup without accepting
  property string cancelText: "Cancel"
  // shown - If the popup is currently open
  property bool shown: false
  // revealed - If a password input is currently shown as plain text, reset to hidden each time the popup opens
  property bool revealed: false

  // accepted - Emitted with the typed text when Enter or the accept button is pressed, the popup closes itself first
  signal accepted(string text)
  // cancelled - Emitted when the popup is closed with Escape, the cancel button, or by clicking outside it
  signal cancelled()

  // open - Clears the input, shows the popup and focuses the input
  function open() {
    input.text = ""
    root.revealed = false
    root.shown = true
    input.forceActiveFocus()
  }

  // close - Hides the popup without emitting anything
  function close() {
    root.shown = false
    input.text = ""
  }

  function accept() {
    const text = input.text
    root.close()
    root.accepted(text)
  }

  function cancel() {
    root.close()
    root.cancelled()
  }

  visible: shown
  z: 2

  MouseArea {
    id: backdrop
    anchors.fill: parent
    onClicked: root.cancel()

    Rectangle {
      id: backdropColor
      anchors.fill: parent
      color: Theme.overlayColor
    }
  }

  Rectangle {
    id: box
    anchors.centerIn: parent
    width: Math.min(parent.width - 24, 320)
    implicitHeight: layout.implicitHeight + 24
    radius: 8
    color: Theme.surfaceColor
    border.width: 1
    border.color: Theme.accentColor

    // Stops clicks inside the box from reaching the backdrop
    MouseArea {
      id: boxClickBlocker
      anchors.fill: parent
    }

    Column {
      id: layout
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.top: parent.top
      anchors.margins: 12
      spacing: 10

      Text {
        id: titleText
        width: parent.width
        visible: text !== ""
        elide: Text.ElideRight
        color: Theme.textColor
        font.family: Theme.textFont
        font.pixelSize: 15
        font.bold: true
        text: root.title
      }

      Text {
        id: messageText
        width: parent.width
        visible: text !== ""
        wrapMode: Text.Wrap
        color: Theme.mutedTextColor
        font.family: Theme.textFont
        font.pixelSize: 13
        text: root.message
      }

      Rectangle {
        id: inputBox
        width: parent.width
        implicitHeight: 36
        radius: 6
        color: Theme.backgroundColor
        border.width: 1
        border.color: input.activeFocus ? Theme.accentColor : Theme.backgroundColor

        TextInput {
          id: input
          anchors.left: parent.left
          anchors.right: revealButton.visible ? revealButton.left : parent.right
          anchors.leftMargin: 10
          anchors.rightMargin: revealButton.visible ? 4 : 10
          anchors.verticalCenter: parent.verticalCenter
          color: Theme.textColor
          selectionColor: Theme.accentColor
          font.family: Theme.textFont
          font.pixelSize: 14
          clip: true
          echoMode: root.password && !root.revealed ? TextInput.Password : TextInput.Normal
          onAccepted: root.accept()
          Keys.onEscapePressed: event => {
            event.accepted = true
            root.cancel()
          }

          Text {
            id: placeholder
            anchors.fill: parent
            visible: input.text === ""
            color: Theme.mutedTextColor
            font: input.font
            text: root.placeholderText
          }
        }

        MouseArea {
          id: revealButton
          anchors.right: parent.right
          anchors.top: parent.top
          anchors.bottom: parent.bottom
          width: 32
          visible: root.password
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
          onClicked: {
            root.revealed = !root.revealed
            input.forceActiveFocus()
          }

          Text {
            id: revealIcon
            anchors.centerIn: parent
            color: revealButton.containsMouse ? Theme.accentColor : Theme.mutedTextColor
            font.family: Theme.iconFont
            font.pixelSize: 16
            text: Icons.get(root.revealed ? "hide" : "show")
          }
        }
      }

      Row {
        id: buttons
        anchors.right: parent.right
        spacing: 8

        Repeater {
          id: buttonRepeater
          model: [
            { label: root.cancelText, primary: false },
            { label: root.acceptText, primary: true },
          ]

          delegate: MouseArea {
            id: button

            required property var modelData

            implicitWidth: buttonLabel.implicitWidth + 24
            implicitHeight: 30
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: modelData.primary ? root.accept() : root.cancel()

            Rectangle {
              id: buttonBackground
              anchors.fill: parent
              radius: 6
              color: button.modelData.primary ? Theme.accentColor : Theme.backgroundColor
              border.width: 1
              border.color: button.containsMouse ? Theme.accentColor : color
            }

            Text {
              id: buttonLabel
              anchors.centerIn: parent
              color: button.modelData.primary ? Theme.surfaceColor : Theme.textColor
              font.family: Theme.textFont
              font.pixelSize: 13
              text: button.modelData.label
            }
          }
        }
      }
    }
  }
}
