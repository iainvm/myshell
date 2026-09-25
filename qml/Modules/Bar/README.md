# Bar

Sits at the top of the screen, showing persistent information about the system, along with some quick access to some system settings.

## Features

- The bar can be set to hidden or visible by default
- The bar only appears on the main monitor, chosen by the shell-wide [`shell.mainMonitor`](../../Settings/README.md#shell) setting. If no main monitor is set or connected, the bar appears on every monitor

## Settings

Set under `bar` in the [settings file](../../Settings/README.md#settings-file).

| Name    | Default        | Description                      |
|---------|----------------|----------------------------------|
| visible | (boolean) true | If the bar is currently visible. |

## Submodules

Submodules can be added to the Bar to add more features

- [Time](./Submodules/Time/README.md)
- [Battery](./Submodules/Battery/README.md)
- [Spacer](./Submodules/Spacer/README.md)
