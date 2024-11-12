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
      root.controller.warn("Attempting to connect to MQTT broker.");
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
            name: "ABORT"
            command: "ABORT"
            text: "ABORT"
            width: actions_view.width
          }
          CommandPairTile {
            action: CommandAction { service: root.controller.commandService }
            name: "FILL VALVE"
            command: "FILL_VALVE"
            width: actions_view.width
          }
          CommandPairTile {
            action: CommandAction { service: root.controller.commandService }
            name: "OX VALVE"
            command: "OX_VALVE"
            width: actions_view.width
          }
          CommandPairTile {
            action: CommandAction { service: root.controller.commandService }
            name: "FUEL VALVE"
            command: "FUEL_VALVE"
            width: actions_view.width
          }
          CommandPairTile {
            action: CommandAction { service: root.controller.commandService }
            name: "PURGE VALVE"
            command: "PURGE_VALVE"
            width: actions_view.width
          }
          CommandTile {
            action: CommandAction { service: root.controller.commandService }
            name: "CMD TEST"
            command: "TEST"
            text: "SEND TEST COMMAND"
            width: actions_view.width
          }
          // Mock timed sequence
          MockTile {
            id: tile
            width: actions_view.width
            implicitHeight: 125

            name: "ACTION 6"

            RowLayout {
              id: timer

              property int countdown: 5000

              Layout.fillWidth: true

              Text {
                id: label

                Layout.fillWidth: true
                text: (timer.countdown/1000).toFixed(3) + " s"
                horizontalAlignment: Text.AlignLeft

              }

              NumberAnimation on countdown {
                to: 0
                duration: timer.countdown
                running: tile.open
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
            color: "red"
          }

        }


        ListView {
          id: list_view

          Layout.fillWidth: true
          Layout.fillHeight: true

          spacing: 5
          clip: true

          model: ListModel {
            id: indicator_model
            ListElement { name: "TANK\nPRESSURE"; topic: "pressure/tank" }
            ListElement { name: "INJECTOR\nPRESSURE"; topic: "pressure/injector" }
            ListElement { name: "FEED\nPRESSURE"; topic: "pressure/feed" }
            ListElement { name: "INJECTOR\nTEMPERATURE"; topic: "temperature/injector" }
            ListElement { name: "VENT\nTEMPERATURE"; topic: "temperature/vent" }
            ListElement { name: "CHAMBER\nTEMPERATURE"; topic: "temperature/chamber" }
            ListElement { name: "LOAD CELL 1"; topic: "load_cell/1" }
            ListElement { name: "LOAD CELL 2"; topic: "load_cell/2" }
            ListElement { name: "SINE WAVE"; topic: "telemetry/sinewave" }
            ListElement { name: "NO TOPIC\nTEST"; topic: "" }
          }

          delegate: Indicator {
            id: indicator_delegate
            width: list_view.width
            implicitHeight: 60

            name: model.name

            MqttSubscriber {
              controller: root.controller
              topic: model.topic
              onMessageReceived: (message) => {
                let payload = JSON.parse(message);
                parent.value = payload["value"]?.concat(" ", payload["units"]) ?? message;
              }
            }
          }
        }
      }
    }
  }
}
