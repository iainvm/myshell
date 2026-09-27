import QtQuick
import qs.Settings
import qs.Components.SearchList

SearchList {
  id: root

  function copy(entry: var) {
    ClipboardHistory.copy(entry)
    Settings.sideMenu.visible = false
  }

  model: ClipboardHistory.entries
  textOf: entry => entry.text
  placeholderText: "Search clipboard history"
  emptyText: "Clipboard history is empty"
  noMatchText: "No matching clipboard entries"
  onActivated: entry => root.copy(entry)

  Component.onCompleted: ClipboardHistory.refresh()

  delegate: Entry {}
}
