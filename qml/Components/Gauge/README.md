# Gauge

A round gauge showing a percentage, e.g. the CPU usage.

## Features

- A 270 degree arc, open at the bottom, filled clockwise from the bottom left up to the value
- A label is shown in the middle
- Changes to the value are animated
- A negative value (e.g. while it's still unknown) shows it empty

## Usage

```qml
import qs.Components.Gauge

Gauge {
  width: 120
  height: 120
  value: root.cpuUsage
  label: "CPU"
}
```

## Properties

| Name      | Type   | Default | Description                        |
|-----------|--------|---------|------------------------------------|
| value     | real   | 0       | How full the gauge is, 0-100.      |
| label     | string | ""      | Text shown in the middle.          |
| lineWidth | real   | 10      | Thickness of the arc.              |
