import QtQuick
import QtQuick.Shapes
import qs.Themes

// A 270 degree arc, open at the bottom, filled clockwise from the bottom left by value
Item {
  id: root

  // value - How full the gauge is, from 0 to 100, a negative value shows it empty
  property real value: 0
  // label - Shown in the middle of the gauge
  property string label
  // lineWidth - Thickness of the arc
  property real lineWidth: 10

  readonly property real radius: Math.min(width, height) / 2 - lineWidth / 2
  property real shownValue: Math.max(0, Math.min(100, value))

  Behavior on shownValue {
    NumberAnimation {
      duration: 300
      easing.type: Easing.OutCubic
    }
  }

  Shape {
    id: arcs
    anchors.fill: parent
    preferredRendererType: Shape.CurveRenderer

    ShapePath {
      id: track
      fillColor: "transparent"
      strokeColor: Theme.surfaceColor
      strokeWidth: root.lineWidth
      capStyle: ShapePath.RoundCap

      PathAngleArc {
        centerX: root.width / 2
        centerY: root.height / 2
        radiusX: root.radius
        radiusY: root.radius
        startAngle: 135
        sweepAngle: 270
      }
    }

    ShapePath {
      id: fill
      fillColor: "transparent"
      strokeColor: root.value > 0 ? Theme.accentColor : "transparent"
      strokeWidth: root.lineWidth
      capStyle: ShapePath.RoundCap

      PathAngleArc {
        centerX: root.width / 2
        centerY: root.height / 2
        radiusX: root.radius
        radiusY: root.radius
        startAngle: 135
        sweepAngle: 270 * root.shownValue / 100
      }
    }
  }

  Text {
    id: labelText
    anchors.centerIn: parent
    color: Theme.mutedTextColor
    font.family: Theme.textFont
    font.pixelSize: 14
    text: root.label
  }
}
