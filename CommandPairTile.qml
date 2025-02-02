import QtQuick

ArmingTile {
  id: root

  required property CommandAction action
  required property string command
  property string parameter_key: "position"
  property string on_value: "open"
  property string off_value: "close"

  Component.onCompleted: {
    action.set_command(root.command);
  }

  implicitHeight: 100

  OnOffControls {
    id: controls
    armed: parent.armed
    implicitWidth: parent.width

    on_text: "OPEN"
    off_text: "CLOSED"

    on_button.text: on_text
    off_button.text: off_text

    on_button.onClicked: {
      action.set_parameter(parameter_key, on_value);
      root.action.execute();
    }
    off_button.onClicked: {
      action.set_parameter(parameter_key, off_value);
      root.action.execute();
    }
  }
}
