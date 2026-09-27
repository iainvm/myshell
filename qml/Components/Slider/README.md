# Slider

A horizontal slider for picking a value in a range, e.g. a volume.

## Features

- A track filled up to the value, with a handle that's highlighted while hovered or dragged
- Dragging or clicking anywhere on it, scrolling over it, or the left/right arrow keys (once clicked) change the value
- It doesn't change `value` itself, it emits `moved(value)` (clamped to the range) so the handler can set the real state, which `value` is bound to
- Setting `interactive` to false dims it and ignores input

## Usage

```qml
import qs.Components.Slider

Slider {
  width: parent.width
  value: root.volume
  onMoved: value => root.volume = value
}
```

## Properties

| Name        | Type | Default | Description                                               |
|-------------|------|---------|-----------------------------------------------------------|
| value       | real | 0       | The value shown.                                          |
| from        | real | 0       | The value at the left end.                                |
| to          | real | 1       | The value at the right end.                               |
| stepSize    | real | 0.05    | How much scrolling or an arrow key changes the value.     |
| interactive | bool | true    | If it takes input, dimmed when false.                     |
| position    | real | 0       | Read-only. Where `value` is between `from` and `to`, 0-1. |

## Signals

| Name         | Description                                                                 |
|--------------|-----------------------------------------------------------------------------|
| moved(value) | Emitted with the new value when it's dragged, clicked, scrolled, or keyed.  |
