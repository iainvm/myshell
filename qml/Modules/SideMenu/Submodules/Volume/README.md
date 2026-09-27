# Volume

The volume settings pick the default audio devices and set their volume, with a media player pinned at the top. Devices come from PipeWire and the media player from MPRIS. The device pickers use the generic [DropDown](../../../../Components/DropDown/README.md) and the volumes the generic [Slider](../../../../Components/Slider/README.md).

## Features

- A media player is pinned at the top of the page, the device settings scroll underneath it
- The media player shows the track's art (or a placeholder), title, artist and the player's name
- The media player has previous, play/pause and next buttons, dimmed when the player doesn't allow them
- When the player reports the track length, a progress bar shows the position and length; dragging or clicking it seeks if the player allows seeking
- The playing player is shown, or the first one if none are playing. With several players, clicking the player's name switches to the next one
- "Nothing playing" is shown when no player is running
- A drop down picks the default input device (microphone), with a slider under it for its volume
- A drop down picks the default output device (speakers), with a slider under it for its volume
- Volume sliders can be dragged, clicked, scrolled, or moved with the arrow keys once clicked, and show the volume as a percentage
- The icon next to each slider mutes or unmutes the device; changing the volume of a muted device unmutes it
- Opened directly with the `quickshell:openVolumeSettings` global shortcut
- Needs PipeWire to be running
