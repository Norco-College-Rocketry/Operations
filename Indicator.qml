import QtQuick
import QtQuick.Layouts

Rectangle {
  id: root

  required property Controller controller
  property string topic: ""
  property string name: "Indicator"
  property string units: ""
  property string value: "N/C"

  border.color: "black"
  border.width: 1

  // Store a reference to the subscription object.
  // Anonymous subscriptions get discarded by the GC.
  property var subscription

  Component.onCompleted: {
    controller.mqtt.stateChanged.connect(() => {
      if (controller.mqtt.state === 2) {
        subscription = controller.mqtt.subscribe(topic)
        subscription.messageReceived.connect((message) => {
          let val = JSON.parse(message)["value"]?.concat(" ", units) ?? message;
          value = val;
        });
      }
    });
  }

  RowLayout {
    anchors.margins: 5
    anchors.fill: parent
    anchors.centerIn: parent

    Text {
      Layout.fillWidth: true
      verticalAlignment: Text.AlignVCenter
      text: name
    }
    Text {
      Layout.fillWidth: true
      verticalAlignment: Text.AlignVCenter
      horizontalAlignment: Text.AlignRight
      text: value
    }
  }
}