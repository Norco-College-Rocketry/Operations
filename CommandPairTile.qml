import QtQuick

ArmingTile {
  id: root

  required property CommandAction action
  required property string command

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
      action.set_parameter("command", "open");
      root.action.execute();
    }
    off_button.onClicked: {
      action.set_parameter("command", "close");
      root.action.execute();
    }
  }
}
