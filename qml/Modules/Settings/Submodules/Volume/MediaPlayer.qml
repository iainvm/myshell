import QtQuick
import Quickshell.Services.Mpris
import qs.Themes
import qs.Components.Slider

Rectangle {
  id: root

  readonly property var players: Array.from(Mpris.players.values)
  // chosenPlayer - The player picked by clicking the player name, used while it's still running
  property MprisPlayer chosenPlayer: null
  // player - The player shown: the chosen one, else the first playing one, else the first one
  readonly property MprisPlayer player: {
    if (chosenPlayer !== null && players.includes(chosenPlayer)) return chosenPlayer
    return players.find(candidate => candidate.isPlaying) ?? players[0] ?? null
  }

  // formatTime - Seconds as m:ss, or h:mm:ss when over an hour
  function formatTime(seconds: real): string {
    const total = Math.max(0, Math.floor(seconds))
    const hours = Math.floor(total / 3600)
    const minutes = Math.floor(total / 60) % 60
    const secs = String(total % 60).padStart(2, "0")
    return hours > 0 ? hours + ":" + String(minutes).padStart(2, "0") + ":" + secs : minutes + ":" + secs
  }

  function switchPlayer() {
    if (root.players.length < 2) return
    const index = root.players.indexOf(root.player)
    root.chosenPlayer = root.players[(index + 1) % root.players.length]
  }

  implicitHeight: content.implicitHeight + content.anchors.margins * 2
  radius: 6
  color: "transparent"
  border.width: 1
  border.color: Theme.surfaceColor

  // position isn't updated by the player while playing, so ask for it again every second
  Timer {
    id: positionTimer
    running: root.player?.isPlaying ?? false
    interval: 1000
    repeat: true
    onTriggered: root.player?.positionChanged()
  }

  Column {
    id: content
    anchors.fill: parent
    anchors.margins: 10
    spacing: 8

    Text {
      id: emptyMessage
      width: parent.width
      visible: root.player === null
      horizontalAlignment: Text.AlignHCenter
      topPadding: 4
      bottomPadding: 4
      color: Theme.mutedTextColor
      font.family: Theme.textFont
      font.pixelSize: 14
      text: "Nothing playing"
    }

    Item {
      id: track
      width: parent.width
      visible: root.player !== null
      implicitHeight: Math.max(artSlot.height, details.implicitHeight)

      Rectangle {
        id: artSlot
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        width: 64
        height: 64
        radius: 4
        color: Theme.surfaceColor
        clip: true

        Image {
          id: art
          anchors.fill: parent
          visible: status === Image.Ready
          source: root.player?.trackArtUrl ?? ""
          sourceSize.width: width
          sourceSize.height: height
          fillMode: Image.PreserveAspectCrop
          asynchronous: true
        }

        Text {
          id: artPlaceholder
          anchors.centerIn: parent
          visible: !art.visible
          color: Theme.mutedTextColor
          font.family: Theme.iconFont
          font.pixelSize: 28
          text: Icons.get("art")
        }
      }

      Column {
        id: details
        anchors.left: artSlot.right
        anchors.right: parent.right
        anchors.leftMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        spacing: 2

        Text {
          id: title
          width: parent.width
          elide: Text.ElideRight
          textFormat: Text.PlainText
          color: Theme.textColor
          font.family: Theme.textFont
          font.pixelSize: 14
          font.bold: true
          text: root.player?.trackTitle || "Unknown title"
        }

        Text {
          id: artist
          width: parent.width
          visible: text !== ""
          elide: Text.ElideRight
          textFormat: Text.PlainText
          color: Theme.textColor
          font.family: Theme.textFont
          font.pixelSize: 13
          text: root.player?.trackArtist ?? ""
        }

        MouseArea {
          id: playerName
          width: parent.width
          implicitHeight: playerNameText.implicitHeight
          enabled: root.players.length > 1
          hoverEnabled: true
          cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
          onClicked: root.switchPlayer()

          Text {
            id: playerNameText
            width: parent.width
            elide: Text.ElideRight
            textFormat: Text.PlainText
            color: playerName.containsMouse ? Theme.accentColor : Theme.mutedTextColor
            font.family: Theme.textFont
            font.pixelSize: 12
            text: (root.players.length > 1 ? Icons.get("switchPlayer") + " " : "") + (root.player?.identity ?? "")
          }
        }
      }
    }

    Item {
      id: progress
      width: parent.width
      visible: (root.player?.lengthSupported ?? false) && root.player.length > 0
      implicitHeight: Math.max(positionText.implicitHeight, seekBar.implicitHeight)

      Text {
        id: positionText
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        color: Theme.mutedTextColor
        font.family: Theme.textFont
        font.pixelSize: 12
        text: root.formatTime(root.player?.position ?? 0)
      }

      Slider {
        id: seekBar
        anchors.left: positionText.right
        anchors.right: lengthText.left
        anchors.leftMargin: 8
        anchors.rightMargin: 8
        anchors.verticalCenter: parent.verticalCenter
        interactive: (root.player?.canSeek ?? false) && (root.player?.positionSupported ?? false)
        opacity: 1
        value: root.player?.position ?? 0
        to: root.player?.length ?? 1
        stepSize: 5
        onMoved: value => root.player.position = value
      }

      Text {
        id: lengthText
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        color: Theme.mutedTextColor
        font.family: Theme.textFont
        font.pixelSize: 12
        text: root.formatTime(root.player?.length ?? 0)
      }
    }

    Row {
      id: controls
      anchors.horizontalCenter: parent.horizontalCenter
      visible: root.player !== null
      spacing: 24

      Repeater {
        id: controlButtons
        model: [
          { icon: "previous", enabled: root.player?.canGoPrevious ?? false, action: () => root.player.previous() },
          { icon: root.player?.isPlaying ? "pause" : "play", enabled: root.player?.canTogglePlaying ?? false, action: () => root.player.togglePlaying() },
          { icon: "next", enabled: root.player?.canGoNext ?? false, action: () => root.player.next() },
        ]

        delegate: MouseArea {
          id: controlButton

          required property var modelData

          implicitWidth: 28
          implicitHeight: 28
          enabled: modelData.enabled
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
          onClicked: modelData.action()

          Text {
            id: controlIcon
            anchors.centerIn: parent
            color: !controlButton.enabled ? Theme.mutedTextColor : (controlButton.containsMouse ? Theme.accentColor : Theme.textColor)
            font.family: Theme.iconFont
            font.pixelSize: 22
            text: Icons.get(controlButton.modelData.icon)
          }
        }
      }
    }
  }
}
