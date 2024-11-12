import QtQuick

Item {
id: root

  signal messageReceived(message: string)

  required property Controller controller
  required property string topic
  property string message // Value received from MQTT payload

  // Must store a reference to the subscription object.
  // Anonymous subscriptions get discarded by the GC.
  property var subscription

  Component.onCompleted: {
    controller.mqtt.stateChanged.connect(() => {
      if (controller.mqtt.state === 2) {
        if (topic === '') {
          controller.warn("Tried to subscribe to empty topic");
        } else {
          subscription = controller.mqtt.subscribe(topic)

          if (!(subscription ?? false)) {
            controller.error("Could not subscribe to MQTT topic '" + topic + "'");
          }

          subscription?.messageReceived.connect((msg) => {
            message = msg;
            messageReceived(msg);
          });
        }
      }
    });
  }

}
