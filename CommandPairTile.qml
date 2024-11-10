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

    on_text: "Open"
    off_text: "Closed"

    on_button.onClicked: {
      action.set_parameter("position", "open");
      root.action.execute();
    }
    off_button.onClicked: {
      action.set_parameter("position", "closed");
      root.action.execute();
    }
  }
}
