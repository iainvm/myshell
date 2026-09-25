# Time

A time display for the Bar

## Features

- Shows the date and/or time using a configurable [Qt date format](https://doc.qt.io/qt-6/qml-qtqml-qt.html#formatDateTime-method) (use `t` for the time zone abbreviation, `ttt` for the UTC offset)
- Hovering over the time switches to a second configurable format, by default [RFC 3339](https://www.rfc-editor.org/rfc/rfc3339) (e.g. `2026-09-25T14:41:37+01:00`)

## Settings

Set under `bar.time` in the [settings file](../../../../Settings/README.md#settings-file).

| Name        | Default                             | Description                                               |
|-------------|-------------------------------------|-----------------------------------------------------------|
| enabled     | (boolean) true                      | If the time submodule is enabled.                         |
| format      | (string) "ddd dd MMM  hh:mm:ss"     | Qt format string shown normally.                          |
| hoverFormat | (string) "yyyy-MM-dd'T'HH:mm:ssttt" | Qt format string shown on hover. Empty disables hovering. |
