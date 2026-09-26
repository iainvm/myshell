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

  function launch(entry: DesktopEntry) {
    entry.execute()
    Settings.settings.visible = false
  }

  textOf: entry => entry.name
  placeholderText: "Search applications"
  emptyText: "No applications found"
  noMatchText: "No matching applications"
  onActivated: entry => root.launch(entry)

  delegate: Entry {}
}
