# Notifications

The notifications settings show the history of the most recently received notifications. The shell is the notification server (it takes the `org.freedesktop.Notifications` D-Bus name), so another notification daemon (e.g. dunst or mako) must not be running, or the shell can't receive notifications.

## Features

- Notifications are collected from when the shell starts, even while the settings drawer is closed
- Only the most recent notifications are kept (see `historySize`), newest first
- The history is kept when the shell hot reloads, but not when it restarts
- Notifications are only recorded, not shown as popups, so apps see them as dismissed once they're received
- Each notification is shown in its own outlined box
- A small header shows the icon and name of the app it came from on the left, and the time since it was received (e.g. `5m ago`) on the right
- The notification's summary is shown in bold under the header, followed by its body
- The body is limited to 4 lines of text
- Hovering over a notification highlights its outline, shows the rest of its body, and changes the time since to the time it was received (see `timestampFormat`)
- If the app has no icon (or it isn't in the icon theme) a placeholder icon is shown
- Opened directly with the `quickshell:openNotifications` global shortcut

## Settings

Set under `notifications` in the [settings file](../../../../Settings/README.md#settings-file).

| Name            | Default                        | Description                                                            |
|-----------------|--------------------------------|------------------------------------------------------------------------|
| historySize     | (int) 10                       | How many of the most recent notifications are kept in the history.     |
| timestampFormat | (string) "yyyy-MM-dd HH:mm:ss" | Qt format string for when a notification was received, shown on hover. |
