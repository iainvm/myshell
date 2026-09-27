# DropDown

A button showing the picked item, clicking it opens a list of items to pick from.

## Features

- The button shows an optional icon and the picked item's text, or placeholder text when nothing is picked
- The list opens under the button and pushes the content below it down, so it's never clipped by a scroll area
- Picking an item closes the list and emits `activated(item)`; `currentItem` isn't changed, so bind it to the real state
- The picked item is highlighted in the list, and `emptyText` is shown when there's nothing to pick
- Escape closes the list if it's open, otherwise it's passed on to the parent (e.g. to close a drawer)

## Usage

```qml
import qs.Components.DropDown

DropDown {
  width: parent.width
  model: root.devices
  currentItem: root.defaultDevice
  textOf: device => device.description
  onActivated: device => root.defaultDevice = device
}
```

## Properties

| Name            | Type     | Default           | Description                                         |
|-----------------|----------|-------------------|-----------------------------------------------------|
| model           | var      | []                | The items that can be picked, a JS array.           |
| currentItem     | var      | null              | The picked item, shown on the button.               |
| textOf          | function | `String(item)`    | Gives the text shown for an item.                   |
| icon            | string   | ""                | Nerd Font glyph shown on the left of the button.    |
| placeholderText | string   | ""                | Shown on the button when `currentItem` is null.     |
| emptyText       | string   | "Nothing to pick" | Shown in the list when `model` is empty.            |
| open            | bool     | false             | If the list is open.                                |

## Signals

| Name            | Description                                   |
|-----------------|-----------------------------------------------|
| activated(item) | Emitted when an item is picked from the list. |
