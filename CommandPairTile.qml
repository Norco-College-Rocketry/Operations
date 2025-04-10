import QtQuick

Tile {
  id: root

  required property CommandAction command
  property string parameter_key: "position"
  property string on_value: "open"
  property string off_value: "close"
  property string name: command.command

  implicitHeight: 100

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

    OnOffControls {
      id: controls
      armed: arming_controls.armed
      implicitWidth: parent.width

      on_text: "OPEN"
      off_text: "CLOSED"

      on_button.text: on_text
      off_button.text: off_text

      on_button.onClicked: {
        root.command.set_parameter(parameter_key, on_value);
        root.command.execute();
      }
      off_button.onClicked: {
        root.command.set_parameter(parameter_key, off_value);
        root.command.execute();
      }
    }
  }
}
