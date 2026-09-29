# Applications

The applications settings show a searchable list of the installed applications (their desktop entries), used to launch them. It's built on the generic [SearchList](../../../../Components/SearchList/README.md) component.

## Features

- When the settings appear the search box is automatically focused
- Applications are listed in alphabetical order, with favourites pinned to the top (also in alphabetical order)
- Applications marked as hidden (`NoDisplay`) aren't listed
- Each application shows its icon on the left, or a placeholder icon if it has none (or it isn't in the icon theme), so every name lines up
- Clicking the star on the right of an application adds it to, or removes it from, the favourites
- Favourites are saved by the shell to `applications.json` in Quickshell's state folder (`~/.local/state/quickshell/by-shell/<shell id>/`), so they're kept across restarts
- When you click an application it launches it and the settings drawer closes
- Applications are launched with [app2unit](https://github.com/Vladimir-csp/app2unit) in their own systemd unit, so they keep running when the shell is stopped or restarted (`systemctl --user stop myshell`)
- Applications are started through the user's login shell (`$SHELL -l`), so they get the same session environment as apps started from a terminal (e.g. VSCodium's integrated terminal keeps the environment from its direnv extension)
- Applications that need a terminal (`Terminal=true`) are run in `shell.terminal`
- When searching and the user hits "Enter" it will launch the top result
- Opened directly with the `quickshell:openApplicationLauncher` global shortcut
