# MenuSwitcher

A drop down menu that switches which menu is shown underneath it, in a scrollable area.

## Features

- A button showing the current menu's icon and name, clicking it opens a list of every menu
- Picking a menu from the list shows it and closes the list
- Escape closes the list if it's open, otherwise it's passed on to the parent (e.g. to close a drawer)
- Setting `active` to false destroys the current menu, so it's rebuilt fresh (e.g. clearing searches) when set back to true
- Each menu is made at least as tall as the area under the button. Taller menus (their `implicitHeight`) scroll in MenuSwitcher's scroll area; a menu that scrolls itself (e.g. SearchList) keeps a small `implicitHeight` and fills the area instead

## Usage

```qml
import qs.Components.MenuSwitcher

MenuSwitcher {
  anchors.fill: parent
  active: root.visible
  menus: [
    Menu {
      name: "Bluetooth"
      icon: "󰂯"
      component: Bluetooth {}
    }
  ]
}
```

Each entry is a `Menu` (`Menu.qml`, a `QtObject`), so a misspelt or wrong-typed field is an error when the shell loads. `component` is a `Component` property, so `Bluetooth {}` there isn't created straight away; QML wraps it in a `Component`, and MenuSwitcher only creates it while that menu is shown.

## Menu

| Name      | Type      | Description                                            |
|-----------|-----------|--------------------------------------------------------|
| name      | string    | The name shown for the menu in the drop down.          |
| icon      | string    | The Nerd Font glyph shown next to the name.            |
| component | Component | What the menu shows, only created while it's current.  |

## Properties

| Name         | Type       | Default | Description                                                             |
|--------------|------------|---------|-------------------------------------------------------------------------|
| menus        | list<Menu> | []      | The menus to switch between.                                            |
| currentIndex | int        | 0       | The index in `menus` of the menu shown.                                 |
| open         | bool       | false   | If the drop down list is open. Reset to false when `active` changes.    |
| active       | bool       | true    | If the current menu is instantiated.                                    |
| currentMenu  | Menu       | null    | Read-only. The entry of `menus` currently shown.                        |

## Functions

| Name       | Description                                                                                                                           |
|------------|---------------------------------------------------------------------------------------------------------------------------------------|
| show(name) | Switches to the menu with that name (case-insensitive) and closes the list. Returns false and logs a warning if there's no such menu. |
