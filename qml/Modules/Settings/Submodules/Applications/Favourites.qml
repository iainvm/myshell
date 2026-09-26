pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: root

  // path - Where the favourites are saved, it's written by the shell so it's kept apart from the read-only settings file
  readonly property string path: Quickshell.statePath("applications.json")
  // ids - The desktop entry ids of the favourite applications
  readonly property list<string> ids: adapter.favourites

  function isFavourite(id: string): bool {
    return root.ids.includes(id)
  }

  function toggle(id: string) {
    adapter.favourites = isFavourite(id)
      ? root.ids.filter(favourite => favourite !== id)
      : root.ids.concat([id])
    file.writeAdapter()
  }

  FileView {
    id: file
    path: root.path
    watchChanges: true
    printErrors: false
    onFileChanged: reload()
    onLoadFailed: error => {
      if (error !== FileViewError.FileNotFound) {
        console.warn("Failed to read favourite applications from", root.path + ":", FileViewError.toString(error))
      }
    }

    JsonAdapter {
      id: adapter

      // favourites - The desktop entry ids of the favourite applications
      property list<string> favourites: []
    }
  }
}
