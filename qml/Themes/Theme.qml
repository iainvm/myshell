pragma Singleton

import QtQuick
import Quickshell
import qs.Themes.Dark

Singleton {
    id: root

    readonly property QtObject palette: Dark {}

    readonly property string textFont: palette.textFont
    readonly property string iconFont: palette.iconFont
    readonly property color textColor: palette.textColor
    readonly property color mutedTextColor: palette.mutedTextColor
    readonly property color accentColor: palette.accentColor
    readonly property color backgroundColor: palette.backgroundColor
    readonly property color surfaceColor: palette.surfaceColor
    readonly property color overlayColor: palette.overlayColor
}
