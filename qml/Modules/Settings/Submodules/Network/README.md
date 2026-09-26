# Network

The network settings show a searchable list of the Wi-Fi networks in range. It's built on the generic [SearchList](../../../../Components/SearchList/README.md) component, and asks for passwords with the generic [PromptPopup](../../../../Components/PromptPopup/README.md).

## Features

- When the settings appear the search box is automatically focused
- Wi-Fi networks are scanned for while the page is open
- Networks are listed connected first, then saved ones, then by signal strength
- Each network shows a signal strength icon, with a lock when it needs a password
- When a network is connected a connected icon is displayed next to its name
- When a network's details are known and saved a saved icon is displayed next to its name
- A network is dimmed while it's connecting or disconnecting
- When a LAN connection is connected, a LAN entry is shown at the top of the list while not searching
- When you click a Wi-Fi network it connects to it, or disconnects it if it's already connected (clicking the LAN entry does nothing)
- If a password is needed, a popup asks for it; if it's wrong the popup asks again. Escape or clicking outside the popup cancels connecting
- Networks that need more than a password (e.g. WPA Enterprise) can't be connected to from here, a warning is logged instead
- When searching and the user hits "Enter" it will click the top result
- Opened directly with the `quickshell:openNetworkSettings` global shortcut
- Needs NetworkManager to be running
