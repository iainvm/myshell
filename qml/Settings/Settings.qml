pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Hyprland

Singleton {
  id: root

  //
  // Shell Settings
  //

  // mainMonitor
  // If empty the shell will render to all monitors
  // If populated it will render to the first monitor if finds that matches that model
  property list<string> mainMonitor: ["G34WQC A", "NE135A1M-NY1"]

  //
  // Bar Settings
  //

  // barVisible - If the bar is currently visible on screen
  property bool barVisible: true
  // barTimeEnabled - If the bar renders the current time
  property bool barTimeEnabled: true
  // barTimeFormat - What time format is shown normally
  property string barTimeFormat: "ddd dd MMM  hh:mm:ss"
  // barTimeHoverFormat - What time format is shown when hovering over the time
  property string barTimeHoverFormat: "yyyy-MM-dd'T'HH:mm:ssttt"

  function toggleBar() {
    barVisible = !barVisible
  }

  GlobalShortcut {
    name: "toggleBar"
    description: "Show or hide the top bar"
    onPressed: root.toggleBar()
  }
}
