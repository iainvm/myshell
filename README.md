# My Shell

My quickshell shell

## Settings

Settings can be changed in `~/.config/myshell/settings.json`, or in any file passed with the `MYSHELL_SETTINGS_FILE` environment variable. See [Settings](./qml/Settings/README.md) for every setting, its default, and where the file is looked for.

## Organisation

```sh
qml
  Modules         # Where all the modules that make up my shell live, each module has it's own folder inside here
    Bar           # A shell module, this one is the Bar that sits at the top of the screen
      Submodules  # Contains the submodules that can be toggled on and off on the parent module (e.g. Bluetooth)
        Bluetooth # A bluetooth icon that shows the connection status, and clicking it will show a searchable list to connect to paired devices
        ...
    Settings      # A drawer on the right of the screen with a drop down menu page per submodule (e.g. Bluetooth)
    ...
  Components      # Generic components that can be reused throughout the shell
    MenuSwitcher  # A drop down menu that switches which menu is shown underneath it
    SearchList    # A search box above a list of items filtered by what's typed
    PromptPopup   # A popup asking for a line of text, e.g. a Wi-Fi password
    SideDrawer
    TabbedPanel
    ...
  Themes          # Stores settings for colouring and style that can be swapped from using the Dark Theme, to Light Theme
    Dark          # Stores the values for the dark theme
    Light         # Stores the values for the light theme
    ...
  shell.qml       # Entrypoint of the entire shell

hyprland-bindings.sh  # Used to store test bindings
```

