import QtQuick

/** Tile containing a button that sends a single verb, parameterless command
 **/
Tile {
  id: root

  required property CommandAction command
  property string name: command.command

  implicitHeight: 80

  Column {
    anchors.fill: parent
    anchors.margins: 5
    spacing: 5

    ArmingControls {
      id: arming_controls
      implicitHeight: childrenRect.height
      implicitWidth: parent.width
      name: root.name
    }

    CommandControls {
      armed: arming_controls.armed
      implicitHeight: childrenRect.height
      implicitWidth: parent.width
      onClicked: () => { tile_timer.start(); }
    }
  }
}
