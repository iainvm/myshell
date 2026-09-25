import QtQuick

QtObject {
  id: root

  // name - The name shown for the menu in the drop down
  property string name
  // icon - The Nerd Font glyph shown next to the name
  property string icon
  // component - What the menu shows when picked, only created while it's the current menu
  property Component component
}
