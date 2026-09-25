# SearchList

A search box above a list of items, filtered by what's typed.

## Features

- The search box is focused when the list is created (turn off with `focusOnLoad`)
- Items are filtered case-insensitively by the text `textOf` returns for them
- Clicking a row, or hitting "Enter" in the search box (for the top result), emits `activated(item)`
- Rows highlight on hover, and their content is supplied by the user of the list
- Shows `emptyText` when there are no items, or `noMatchText` when nothing matches the search

## Usage

```qml
import qs.Components.SearchList

SearchList {
  model: ["one", "two", "three"]
  textOf: item => item
  placeholderText: "Search numbers"
  onActivated: item => console.log(item)

  delegate: Text {
    property var modelData
    text: modelData ?? ""
  }
}
```

The `delegate` must declare `property var modelData` (or a stricter type, e.g. `property BluetoothDevice modelData`) to receive its item. It's not a `required` property, so it's briefly `null` while the row is created; guard against that (`modelData?.name ?? ""`).

If the file using SearchList uses its own `Icons.qml` next to it, either move the row into its own file (like Bluetooth's `Entry.qml`) or import SearchList with a qualifier (`import qs.Components.SearchList as Components`, then `Components.SearchList {}`). Otherwise SearchList's `Icons` singleton hides the local one.

## Properties

| Name            | Type      | Default                          | Description                                                        |
|-----------------|-----------|----------------------------------|--------------------------------------------------------------------|
| model           | list      | []                               | The items to search through, shown in the order given.             |
| textOf          | function  | `item => item?.name ?? String(item)` | Returns the text an item is matched against.                   |
| delegate        | Component | null                             | The content of each row.                                           |
| placeholderText | string    | "Search"                         | Shown in the search box while it's empty.                          |
| emptyText       | string    | "Nothing to show"                | Shown when `model` is empty.                                       |
| noMatchText     | string    | "No matches"                     | Shown when `model` has items but none match the search.            |
| focusOnLoad     | bool      | true                             | If the search box takes keyboard focus when created.               |
| query           | read-only | ""                               | The lowercased search text.                                        |
| results         | read-only | []                               | The items of `model` matching the search.                          |

## Signals and functions

| Name              | Description                                                                 |
|-------------------|-----------------------------------------------------------------------------|
| activated(item)   | A row was clicked, or Enter was pressed with at least one result.            |
| focusSearch()     | Gives the search box keyboard focus.                                         |
