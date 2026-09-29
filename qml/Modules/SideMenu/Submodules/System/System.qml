import QtQuick
import Quickshell
import qs.Settings
import qs.Themes
import qs.Components.Gauge

Column {
  id: root

  // sortBy - Which column the processes are ordered by, "cpu" or "memory", busiest first
  property string sortBy: "cpu"
  readonly property var topProcesses: stats.processes
    .slice()
    .sort((first, second) => second[root.sortBy] - first[root.sortBy])
    .slice(0, Math.max(0, Settings.system.processCount))

  readonly property var actions: [
    { name: "Power Off", icon: Icons.get("powerOff"), shortcut: "P", key: Qt.Key_P, command: Settings.system.powerOffCommand },
    { name: "Hibernate", icon: Icons.get("hibernate"), shortcut: "H", key: Qt.Key_H, command: Settings.system.hibernateCommand },
    { name: "Lock", icon: Icons.get("lock"), shortcut: "L", key: Qt.Key_L, command: Settings.system.lockCommand },
    { name: "Logout", icon: Icons.get("logout"), shortcut: "E", key: Qt.Key_E, command: Settings.system.logoutCommand },
  ]

  // run - Closes the side menu, then runs an action's command detached, so it keeps going if the shell exits
  function run(action: var) {
    const command = Array.from(action.command)
    if (command.length === 0) return
    console.info("Running", action.name + ":", JSON.stringify(command))
    Settings.sideMenu.visible = false
    Quickshell.execDetached(command)
  }

  function formatTemperature(celsius: real): string {
    return isNaN(celsius) ? "N/A" : Math.round(celsius) + "°C"
  }

  spacing: 16
  focus: true

  // Only unmodified keys run actions, anything else (e.g. Escape) is passed on to the side menu
  Keys.onPressed: event => {
    const modifiers = Qt.ControlModifier | Qt.AltModifier | Qt.MetaModifier
    const action = (event.modifiers & modifiers) ? undefined : root.actions.find(candidate => candidate.key === event.key)
    if (action && !event.isAutoRepeat) {
      root.run(action)
      event.accepted = true
    } else {
      event.accepted = false
    }
  }

  Component.onCompleted: root.forceActiveFocus()

  SystemStats {
    id: stats
  }

  Row {
    id: powerButtons
    width: parent.width
    spacing: 8

    Repeater {
      id: powerRepeater
      model: root.actions

      delegate: PowerButton {
        required property var modelData

        width: (powerButtons.width - powerButtons.spacing * (root.actions.length - 1)) / root.actions.length
        name: modelData.name
        icon: modelData.icon
        shortcut: modelData.shortcut
        onClicked: root.run(modelData)
      }
    }
  }

  Column {
    id: cpuUsage
    anchors.horizontalCenter: parent.horizontalCenter
    spacing: 0

    Gauge {
      id: cpuGauge
      anchors.horizontalCenter: parent.horizontalCenter
      width: 140
      height: 140
      value: stats.cpuUsage
      label: "CPU"
    }

    Text {
      id: cpuPercentage
      anchors.horizontalCenter: parent.horizontalCenter
      topPadding: -16
      color: Theme.textColor
      font.family: Theme.textFont
      font.pixelSize: 20
      font.bold: true
      text: stats.cpuUsage < 0 ? "--%" : Math.round(stats.cpuUsage) + "%"
    }
  }

  Row {
    id: temperatures
    width: parent.width
    spacing: 8

    Repeater {
      id: temperatureRepeater
      model: [
        { name: "CPU", icon: Icons.get("cpu"), value: stats.cpuTemperature },
        { name: "GPU", icon: Icons.get("gpu"), value: stats.gpuTemperature },
      ]

      delegate: Rectangle {
        id: temperature

        required property var modelData

        width: (temperatures.width - temperatures.spacing) / 2
        implicitHeight: 40
        radius: 6
        color: Theme.surfaceColor

        Row {
          id: temperatureLabel
          anchors.centerIn: parent
          spacing: 8

          Text {
            id: temperatureIcon
            anchors.verticalCenter: parent.verticalCenter
            color: Theme.accentColor
            font.family: Theme.iconFont
            font.pixelSize: 18
            text: temperature.modelData.icon
          }

          Text {
            id: temperatureName
            anchors.verticalCenter: parent.verticalCenter
            color: Theme.mutedTextColor
            font.family: Theme.textFont
            font.pixelSize: 13
            text: temperature.modelData.name
          }

          Text {
            id: temperatureValue
            anchors.verticalCenter: parent.verticalCenter
            color: Theme.textColor
            font.family: Theme.textFont
            font.pixelSize: 14
            font.bold: true
            text: root.formatTemperature(temperature.modelData.value)
          }
        }
      }
    }
  }

  Column {
    id: processes
    width: parent.width
    spacing: 2

    Item {
      id: headings
      width: parent.width
      implicitHeight: 24

      Text {
        id: processHeading
        anchors.left: parent.left
        anchors.leftMargin: 6
        anchors.verticalCenter: parent.verticalCenter
        color: Theme.mutedTextColor
        font.family: Theme.textFont
        font.pixelSize: 12
        text: "Process"
      }

      Repeater {
        id: sortHeadings
        model: [
          { name: "CPU", key: "cpu", rightMargin: 28 + 64 },
          { name: "RAM", key: "memory", rightMargin: 28 },
        ]

        delegate: MouseArea {
          id: sortHeading

          required property var modelData
          readonly property bool sorted: root.sortBy === modelData.key

          anchors.right: parent.right
          anchors.rightMargin: modelData.rightMargin
          anchors.verticalCenter: parent.verticalCenter
          width: modelData.key === "cpu" ? 56 : 64
          height: parent.height
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
          onClicked: root.sortBy = modelData.key

          Text {
            id: sortHeadingText
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            color: sortHeading.sorted || sortHeading.containsMouse ? Theme.accentColor : Theme.mutedTextColor
            font.family: Theme.textFont
            font.pixelSize: 12
            font.bold: sortHeading.sorted
            text: (sortHeading.sorted ? Icons.get("sorted") + " " : "") + sortHeading.modelData.name
          }
        }
      }
    }

    Text {
      id: loadingMessage
      width: parent.width
      visible: !stats.sampled
      horizontalAlignment: Text.AlignHCenter
      topPadding: 8
      color: Theme.mutedTextColor
      font.family: Theme.textFont
      font.pixelSize: 14
      text: "Loading processes"
    }

    Repeater {
      id: processRepeater
      // A count rather than the list, so rows are kept (with their hover state) when the processes refresh
      model: root.topProcesses.length

      delegate: Entry {
        id: processEntry

        required property int index

        width: processes.width
        cpuWidth: 56
        memoryWidth: 64
        process: root.topProcesses[index]
        program: stats.programOf(process?.pid ?? -1)
        onKilled: if (processEntry.process) stats.kill(processEntry.process.pid)
      }
    }
  }
}
