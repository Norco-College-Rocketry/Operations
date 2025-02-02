import QtQuick
import QtQuick.Layouts

Window {
  id: root

  MqttCommandService {
    id: mqtt_command_service
    client: root.controller.mqtt
    topic: root.controller.settings.value("mqtt/command_topic", "commands")
  }

  property Controller controller: Controller {
    mqtt: MqttClient {
      hostname: root.controller.settings.value("mqtt/hostname", "localhost")
      port: root.controller.settings.value("mqtt/port", 1883)
    }
    commandService: mqtt_command_service.interface
    settings: QSettings { }
  }

  Timer {
    id: mqtt_timeout_timer
    interval: 2500
    running: false
    repeat: true

    onTriggered: () => {
      root.controller.warn("Attempting to connect to MQTT broker (retry: "+(interval/1000).toString()+"s)");
      root.controller.mqtt.connectToHost();
    }
  }

  Component.onCompleted: {
    root.controller.mqtt.connectToHost();
    root.controller.mqtt.onStateChanged.connect(() => {
      switch (root.controller.mqtt.state) {
        case 0:
          mqtt_timeout_timer.running = true;
          break;
        case 2:
          mqtt_timeout_timer.running = false;
          break;
      }
    });
    root.controller.initialize_settings(root.controller.settings);
  }

  width: 480
  height: 800
  visible: true
  title: qsTr("GSC Operations Application - Norco College Rocketry")

  color: "#6D8F99"

  GridLayout {
    anchors.fill: parent
    columns: 2
    anchors.margins: 5

    Rectangle {
      id: actions_container
      Layout.preferredWidth: 50
      Layout.fillWidth: true
      Layout.fillHeight: true

      border.color: "black"
      border.width: 1
      radius: 5
      color: "#FAF4DA"

      Flickable {
        anchors.fill: parent
        anchors.margins: 5
        clip: true

        ObjectModel {
          id: action_model
          CommandTile {
            action: CommandAction { service: root.controller.commandService }
            command: "ABORT"
            width: actions_view.width
          }
          CommandTile {
            action: CommandAction { service: root.controller.commandService }
            command: "IGNITE"
            width: actions_view.width
          }
          CommandPairTile {
            action: CommandAction { service: root.controller.commandService }
            Component.onCompleted: action.set_parameter("valve", "FV01");
            implicitHeight: 110
            name: "MAIN OX\nVALVE"
            command: "VALVE"
            width: actions_view.width
          }
          CommandPairTile {
            action: CommandAction { service: root.controller.commandService }
            Component.onCompleted: action.set_parameter("valve", "FV02");
            implicitHeight: 110
            name: "MAIN FUEL\nVALVE"
            command: "VALVE"
            width: actions_view.width
          }
          CommandPairTile {
            action: CommandAction { service: root.controller.commandService }
            Component.onCompleted: action.set_parameter("valve", "FV03");
            name: "VENT VALVE"
            command: "VALVE"
            width: actions_view.width
          }
          CommandPairTile {
            action: CommandAction { service: root.controller.commandService }
            Component.onCompleted: action.set_parameter("valve", "FV04");
            name: "FILL VALVE"
            command: "VALVE"
            width: actions_view.width
          }
          CommandTile {
            action: CommandAction { service: root.controller.commandService }
            name: "SELF TEST"
            command: "SELFTEST"
            width: actions_view.width
          }
        }

        ListView {
          id: actions_view
          anchors.fill: parent

          spacing: 5
          model: action_model
        }
      }
    }

    Rectangle {
      id: readout_container

      Layout.preferredWidth: 50
      Layout.fillWidth: true
      Layout.fillHeight: true

      radius: 4
      color: "#FAF4DA"
      border.color: "black"
      border.width: 1

      ColumnLayout {
        anchors.fill: parent
        anchors.margins: 5

        RowLayout {
          id: status_indicators_layout
          Layout.fillWidth: true

          StatusIndicator {
            Layout.fillWidth: true
            Layout.preferredHeight: 50

            text: "BROKER"
            color: {
              switch (root.controller.mqtt.state) {
                case 0:
                  return "red";
                  break;
                case 1:
                  return "yellow";
                  break;
                case 2:
                  return "green";
                  break;
              }
            }
          }

          StatusIndicator {
            Layout.fillWidth: true
            Layout.preferredHeight: 50
            text: "TSDB"
            color: "red"
          }

        }


        ListView {
          id: value_indicators_view

          Layout.fillWidth: true
          Layout.fillHeight: true

          spacing: 5
          clip: true

          model: ListModel {
            id: indicator_model
            ListElement { name: "TANK\nPRESSURE"; topic: "telemetry/tank/pressure" }
            ListElement { name: "INJECTOR\nPRESSURE"; topic: "telemetry/injector/pressure" }
            ListElement { name: "FEED\nPRESSURE"; topic: "telemetry/feed/pressure" }
            ListElement { name: "INJECTOR\nTEMPERATURE"; topic: "telemetry/injector/temperature" }
            ListElement { name: "VENT\nTEMPERATURE"; topic: "telemetry/vent/temperature" }
            ListElement { name: "CHAMBER\nTEMPERATURE"; topic: "telemetry/chamber/temperature" }
            ListElement { name: "LOAD CELL 1"; topic: "telemetry/weight/1" }
            ListElement { name: "LOAD CELL 2"; topic: "telemetry/weight/2" }
            ListElement { name: "SINE WAVE"; topic: "telemetry/sinewave" }
            ListElement { name: "NO TOPIC\nTEST"; topic: "" }
          }

          delegate: Indicator {
            id: indicator_delegate
            width: value_indicators_view.width
            implicitHeight: 60

            name: model.name

            MqttSubscriber {
              controller: root.controller
              topic: model.topic
              onMessageReceived: (message) => {
                let payload = JSON.parse(message);
                parent.value = payload.value.toFixed(3) + " "  + payload.unit ?? message;
              }
            }
          }
        }
      }
    }
  }
}
