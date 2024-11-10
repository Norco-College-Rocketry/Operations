import QtQuick
import QtQuick.Controls

ArmedActionTile {
  id: root

  required property CommandAction command_action
  property string command: "TEST"

  Component.onCompleted: {
    command_action.set_command(root.command);
  }

  implicitHeight: 80

  name: "CMD TEST"

  Button {
    implicitWidth: parent.width
    text: "SEND TEST COMMAND"
    enabled: parent.armed
    onClicked: {
      command_action.execute();
    }
  }
}
