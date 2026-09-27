import QtQuick
import qs.Themes

Item {
  id: root

  // value - The value shown, it isn't changed by dragging, handle moved() to set it
  property real value: 0
  // from - The value at the left end
  property real from: 0
  // to - The value at the right end
  property real to: 1
  // stepSize - How much the scroll wheel and arrow keys change the value
  property real stepSize: 0.05
  // interactive - Set false to dim the slider and ignore input
  property bool interactive: true

  readonly property real position: to === from ? 0 : Math.max(0, Math.min(1, (value - from) / (to - from)))

  // moved - Emitted with the new value when the user drags, clicks, scrolls, or uses the arrow keys
  signal moved(real value)

  function clamp(newValue: real): real {
    return Math.max(Math.min(from, to), Math.min(Math.max(from, to), newValue))
  }

  function moveTo(newValue: real) {
    root.moved(root.clamp(newValue))
  }

  function moveToX(x: real) {
    const usable = Math.max(1, track.width)
    root.moveTo(root.from + Math.max(0, Math.min(1, (x - track.x) / usable)) * (root.to - root.from))
  }

  implicitHeight: 20
  opacity: interactive ? 1 : 0.5

  Keys.onLeftPressed: if (root.interactive) root.moveTo(root.value - root.stepSize)
  Keys.onRightPressed: if (root.interactive) root.moveTo(root.value + root.stepSize)

  Rectangle {
    id: track
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.leftMargin: handle.width / 2
    anchors.rightMargin: handle.width / 2
    anchors.verticalCenter: parent.verticalCenter
    height: 4
    radius: 2
    color: Theme.surfaceColor

    Rectangle {
      id: fill
      width: parent.width * root.position
      height: parent.height
      radius: parent.radius
      color: Theme.accentColor
    }
  }

  Rectangle {
    id: handle
    x: track.x + track.width * root.position - width / 2
    anchors.verticalCenter: parent.verticalCenter
    width: 14
    height: 14
    radius: 7
    color: input.containsMouse || input.pressed ? Theme.accentColor : Theme.textColor
  }

  MouseArea {
    id: input
    anchors.fill: parent
    enabled: root.interactive
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    preventStealing: true
    onPressed: mouse => {
      root.forceActiveFocus()
      root.moveToX(mouse.x)
    }
    onPositionChanged: mouse => {
      if (pressed) root.moveToX(mouse.x)
    }
    onWheel: wheel => {
      const direction = wheel.angleDelta.y !== 0 ? wheel.angleDelta.y : wheel.angleDelta.x
      if (direction !== 0) root.moveTo(root.value + (direction > 0 ? root.stepSize : -root.stepSize))
    }
  }
}
