# PromptPopup

A simple popup asking for a single line of text (e.g. a password), shown over whatever it's placed in.

## Features

- A title, an optional message, a text input and accept/cancel buttons in a box centred over a dimmed backdrop
- The input is focused when the popup opens, and can be masked for passwords with `password`
- A masked input has an eye button on its right that shows or hides what's typed; it's hidden again each time the popup opens
- "Enter" or the accept button emits `accepted(text)`; "Escape", the cancel button, or clicking outside the box emits `cancelled()`
- Escape is used by the popup, so it doesn't also close a drawer the popup is in
- The popup closes itself before emitting either signal, so a handler can reopen it (e.g. after a wrong password)

## Usage

```qml
import qs.Components.PromptPopup

PromptPopup {
  id: prompt
  anchors.fill: parent
  title: "Password"
  placeholderText: "Password"
  password: true
  acceptText: "Connect"
  onAccepted: text => console.log(text)
  onCancelled: console.log("cancelled")
}

// prompt.open()
```

Place it last among its siblings (it also has `z: 2`) and fill the area it should cover. Focus isn't handed back when it closes, so give focus back to what should have it in the `accepted`/`cancelled` handlers.

## Properties

| Name            | Type   | Default  | Description                                                    |
|-----------------|--------|----------|----------------------------------------------------------------|
| title           | string | ""       | The heading of the popup, hidden when empty.                   |
| message         | string | ""       | Text under the title, hidden when empty.                       |
| placeholderText | string | ""       | Shown in the input while it's empty.                           |
| password        | bool   | false    | If the input is masked, with an eye button to reveal it.       |
| acceptText      | string | "OK"     | The label of the accept button.                                |
| cancelText      | string | "Cancel" | The label of the cancel button.                                |
| shown           | bool   | false    | If the popup is open. Prefer `open()`, which also focuses it.  |
| revealed        | bool   | false    | If a masked input is shown as plain text. Reset by `open()`.   |

## Signals and functions

| Name           | Description                                                         |
|----------------|---------------------------------------------------------------------|
| accepted(text) | The input was accepted, with what was typed.                        |
| cancelled()    | The popup was closed without accepting.                             |
| open()         | Clears the input, hides a revealed password, shows the popup and focuses the input. |
| close()        | Hides the popup and clears the input without emitting anything.     |
