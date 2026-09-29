import QtQuick
import Quickshell
import qs.Settings
import qs.Components.SearchList

SearchList {
  id: root

  // model - Visible applications, favourites first, each group in alphabetical order
  model: Array.from(DesktopEntries.applications.values)
    .filter(entry => !entry.noDisplay)
    .sort((first, second) => (Favourites.isFavourite(second.id) - Favourites.isFavourite(first.id))
      || first.name.localeCompare(second.name))

  // launch - Starts the application in its own systemd unit through app2unit, so it isn't
  // part of the shell's service and survives the shell being stopped or restarted
  function launch(entry: DesktopEntry) {
    const command = entry.runInTerminal
      ? ["app2unit", "--", Settings.shell.terminal, ...entry.command]
      : ["app2unit", "--", ...entry.command]

    Quickshell.execDetached({
      command: command,
      workingDirectory: entry.workingDirectory
    })
    Settings.sideMenu.visible = false
  }

  textOf: entry => entry.name
  placeholderText: "Search applications"
  emptyText: "No applications found"
  noMatchText: "No matching applications"
  onActivated: entry => root.launch(entry)

  delegate: Entry {}
}
