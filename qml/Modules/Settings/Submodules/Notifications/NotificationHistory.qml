pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Notifications
import qs.Settings

Singleton {
  id: root

  // size - How many notifications are kept, the newest first
  readonly property int size: Math.max(0, Settings.settings.notifications.historySize)
  // entries - The received notifications, newest first, as plain objects so they outlive the notification itself
  // Each has: appName, appIcon, summary, body, time (milliseconds since the epoch)
  readonly property var entries: JSON.parse(persistent.entries).slice(0, root.size)

  // iconOf - The path of the notification's app icon, or "" if it has none or it isn't in the icon theme
  function iconOf(notification: Notification): string {
    const icon = notification.appIcon !== "" ? notification.appIcon : (DesktopEntries.byId(notification.desktopEntry)?.icon ?? "")
    if (icon === "") return ""
    if (icon.startsWith("/")) return "file://" + icon
    if (icon.includes("://")) return icon
    return Quickshell.iconPath(icon, true)
  }

  function add(notification: Notification) {
    const entry = {
      appName: notification.appName,
      appIcon: root.iconOf(notification),
      summary: notification.summary,
      body: notification.body,
      time: Date.now(),
    }
    persistent.entries = JSON.stringify([entry].concat(root.entries).slice(0, root.size))
  }

  // Kept across hot reloads, which would otherwise empty the history
  // Stored as JSON because a JS array can't be carried over to the reloaded engine
  PersistentProperties {
    id: persistent
    reloadableId: "notificationHistory"

    property string entries: "[]"
  }

  NotificationServer {
    id: server
    // Notifications are only recorded, not tracked, so they're treated as dismissed once received
    keepOnReload: false
    bodySupported: true
    onNotification: notification => root.add(notification)
  }
}
