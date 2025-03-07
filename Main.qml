import QtQuick
import QtQuick.Layouts

Window {
  id: root

  flags: Qt.Window | Qt.FramelessWindowHint

  Item {
    id: keys_handler
    property bool is_fullscreen: true
    focus: true
    Keys.onPressed: (event) => {
      if (event.key === Qt.Key_F11) {
        root.flags = keys_handler.is_fullscreen ? Qt.Window : Qt.Window | Qt.FramelessWindowHint;
        keys_handler.is_fullscreen = !keys_handler.is_fullscreen;
      }
    }
  }

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
          // CommandTile {
          //   action: CommandAction { service: root.controller.commandService }
          //   command: "ABORT"
          //   width: actions_view.width
          // }
          // CommandTile {
          //   action: CommandAction { service: root.controller.commandService }
          //   command: "IGNITE"
          //   width: actions_view.width
          // }
          // CommandPairTile {
          //   action: CommandAction { service: root.controller.commandService }
          //   Component.onCompleted: action.set_parameter("valve", "FV1-E");
          //   implicitHeight: 110
          //   name: "MAIN OX\nVALVE"
          //   command: "VALVE"
          //   width: actions_view.width
          // }
          // CommandPairTile {
          //   action: CommandAction { service: root.controller.commandService }
          //   Component.onCompleted: action.set_parameter("valve", "FV2-E");
          //   implicitHeight: 110
          //   name: "MAIN FUEL\nVALVE"
          //   command: "VALVE"
          //   width: actions_view.width
          // }
          // CommandPairTile {
          //   action: CommandAction { service: root.controller.commandService }
          //   Component.onCompleted: action.set_parameter("valve", "FV3-E");
          //   name: "VENT VALVE"
          //   command: "VALVE"
          //   width: actions_view.width
          // }
          // CommandPairTile {
          //   action: CommandAction {
          //     service: root.controller.commandService;
          //     command: "VALVE";
          //     Component.onCompleted: set_parameter("valve", "FV-S");
          //   }
          //   name: "FILL VALVE"
          //   width: actions_view.width
          // }
          Tile {
            implicitHeight: 150
            implicitWidth: actions_view.width

            Column {
              anchors.fill: parent
              anchors.margins: 5
              spacing: 5

              ArmingControls {
                id: arming_controls
                implicitHeight: childrenRect.height
                implicitWidth: parent.width
                name: "SELF TEST"
              }

              CommandTile {
                action: CommandAction { service: root.controller.commandService; command: "SELFTEST" }
                armed: arming_controls.armed
                implicitHeight: childrenRect.height
                implicitWidth: parent.width
              }

              CommandTile {
                action: CommandAction { service: root.controller.commandService; command: "SELFTEST" }
                armed: arming_controls.armed
                implicitHeight: childrenRect.height
                implicitWidth: parent.width
              }
            }
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
            color: "gray"
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
            ListElement { name: "FUEL\nPRESSURE"; topic: "telemetry/tank/oxidizer/pressure" }
            ListElement { name: "OX\nPRESSURE"; topic: "telemetry/tank/fuel/pressure" }
            ListElement { name: "SUPPLY\nPRESSURE"; topic: "telemetry/supply/pressure" }
            ListElement { name: "INJECTOR\nPRESSURE"; topic: "telemetry/injector/pressure" }
            ListElement { name: "FEED\nPRESSURE"; topic: "telemetry/feed/pressure" }
            ListElement { name: "CHAMBER\nPRESSURE"; topic: "telemetry/chamber/pressure" }
            ListElement { name: "LOAD CELL 1"; topic: "telemetry/tank/weight/1" }
            ListElement { name: "LOAD CELL 2"; topic: "telemetry/tank/weight/2" }
            ListElement { name: "LOAD CELL 3"; topic: "telemetry/tank/weight/3" }
            ListElement { name: "LOAD CELL 4"; topic: "telemetry/tank/weight/4" }
            ListElement { name: "VENT\nTEMPERATURE"; topic: "telemetry/tank/vent/temperature" }
            ListElement { name: "CHAMBER\nTEMPERATURE"; topic: "telemetry/chamber/temperature" }
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
