import QtQuick
import QtQuick.Controls

ArmingTile {
  id: root

  required property CommandAction action
  required property string command

  property alias text: button.text

  Component.onCompleted: {
    action.set_command(root.command);
  }

  implicitHeight: 80

  Button {
    id: button
    implicitWidth: parent.width
    text: "SEND COMMAND"
    enabled: parent.armed
    onClicked: {
      root.action.execute();
    }
  }
}
