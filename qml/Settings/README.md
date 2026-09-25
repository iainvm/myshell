# Settings

Here contains all the globally accessible features of the shell.

## Settings file

Any setting below can be overridden in a JSON settings file. Settings are grouped into nested objects matching their dotted name (`bar.time.format` is `{"bar": {"time": {"format": ...}}}`), and anything left out keeps its default.

```json
{
  "shell": {
    "mainMonitor": ["23MP65"]
  },
  "bar": {
    "time": {
      "format": "hh:mm"
    }
  }
}
```

The file is looked for in this order:

1. `$MYSHELL_SETTINGS_FILE`, if set and not empty (e.g. `MYSHELL_SETTINGS_FILE=./test.json task run` to try out a test file)
2. `$XDG_CONFIG_HOME/myshell/settings.json`, if `XDG_CONFIG_HOME` is set
3. `~/.config/myshell/settings.json`

Only the first location found is used. If `MYSHELL_SETTINGS_FILE` points at a file that doesn't exist, the defaults are used rather than falling back to the others.

- The file is optional. Without it, every setting uses its default.
- Changes are applied as soon as the file is saved, without restarting the shell.
- Removing a top-level section (e.g. all of `bar`) or a top-level key puts it back to its default. Removing a key *inside* a section (e.g. just `bar.visible`) keeps its last value until the shell is restarted.
- Each time the file is loaded, the shell logs `Loaded settings from <path>` at INFO level, so the log shows which file is in use.
- If the file has invalid JSON, a warning is logged instead and the last good values stay in place.
- The folder containing the file must exist when the shell starts for it to notice the file being created later. Otherwise, restart the shell after creating it.
- The file is only read, never written. Changes made while running (e.g. hiding the bar with the shortcut) aren't saved, and are replaced by the file's value the next time it's saved.

## Shell

| Name              | Default   | Description                                                                                                                                                                                  |
|-------------------|-----------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| shell.mainMonitor | (list) [] | Priority list of monitor models (the `model:` line in `hyprctl monitors`). The shell shows on the first one connected. If the list is empty or none are connected, it shows on all monitors. |

## Bar

| Name                  | Default                             | Description                                                    |
|-----------------------|-------------------------------------|----------------------------------------------------------------|
| bar.visible           | (boolean) true                      | If the bar is currently visible.                               |
| bar.battery.enabled   | (boolean) true                      | If the Battery submodule of the bar in enabled.                |
| bar.battery.maxCharge | (int) 80                            | The maximum charge the battery charges to.                     |
| bar.time.enabled      | (boolean) true                      | If the Time submodule of the bar is enabled.                   |
| bar.time.format       | (string) "ddd dd MMM  hh:mm:ss"     | Qt format string the Time submodule shows.                     |
| bar.time.hoverFormat  | (string) "yyyy-MM-dd'T'HH:mm:ssttt" | Qt format string shown on hover (RFC 3339). Empty disables it. |

## Settings

| Name             | Default        | Description                                                        |
|------------------|----------------|--------------------------------------------------------------------|
| settings.visible | (boolean) true | If the settings drawer is currently visible (open on startup).     |
