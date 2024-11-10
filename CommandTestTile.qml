import QtQuick
import QtQuick.Controls

ArmedActionTile {
  id: root

  required property MqttClient mqtt
  property string topic: "command"
  property string command: "TEST"

  implicitHeight: 80

  name: "CMD TEST"

  Button {
    implicitWidth: parent.width
    text: "SEND TEST COMMAND"
    enabled: parent.armed
    onClicked: { mqtt.publish(root.topic, root.command) }
  }
}
