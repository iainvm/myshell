# Settings

Here contains all the globally accessible features of the shell.

## Shell

| Name        | Default                             | Description                                                                                                                                                                                  |
|-------------|-------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| mainMonitor | (list) ["G34WQC A", "NE135A1M-NY1"] | Priority list of monitor models (the `model:` line in `hyprctl monitors`). The shell shows on the first one connected. If the list is empty or none are connected, it shows on all monitors. |

## Bar

| Name               | Default                             | Description                                                    |
|--------------------|-------------------------------------|----------------------------------------------------------------|
| barVisible         | (boolean) true                      | If the bar is currently visible.                               |
| barBatteryEnabled  | (boolean) true                      | If the Battery submodule of the bar in enabled.                |
| barTimeEnabled     | (boolean) true                      | If the Time submodule of the bar is enabled.                   |
| barTimeFormat      | (string) "ddd dd MMM  hh:mm:ss"     | Qt format string the Time submodule shows.                     |
| barTimeHoverFormat | (string) "yyyy-MM-dd'T'HH:mm:ssttt" | Qt format string shown on hover (RFC 3339). Empty disables it. |
