# Battery

A battery icon for the Bar

## Features

- The icon shows the battery charged state
- The icon shows whether battery charging state
- Hovering over the icon will change to show battery percentage charge
- If the battery is `pending-charge` and at a configurable `max_charge` percentage (default: `80`) then a configurable icon will display
- The icon is hidden on devices without a laptop battery

## Settings

Set under `bar.battery` in the [settings file](../../../../Settings/README.md#settings-file).

| Name      | Default        | Description                                |
|-----------|----------------|--------------------------------------------|
| enabled   | (boolean) true | If the battery submodule is enabled.       |
| maxCharge | (int) 80       | The maximum charge the battery charges to. |
