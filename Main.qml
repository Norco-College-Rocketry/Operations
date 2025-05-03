import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

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
          CommandTile {
            command: CommandAction { service: root.controller.commandService; command: "ABORT" }
            width: actions_view.width
          }
          CommandTile {
            command: CommandAction { service: root.controller.commandService; command: "LAUNCH" }
            width: actions_view.width
          }

          Tile {
            id: tile_root
            implicitHeight: 135
            implicitWidth: actions_view.width

            property CommandAction action: CommandAction {
              service: root.controller.commandService;
              command: "VALVE";
              Component.onCompleted: set_parameter("valve", "SV-N202");
            }

            property double default_interval: 2
            property double countdown: 0

            Column {
              anchors.fill: parent
              anchors.margins: 5
              spacing: 5

              ArmingControls {
                id: arming_controls
                implicitHeight: childrenRect.height
                implicitWidth: parent.width
                name: "VENT\nSEQUENCE"
              }

              Row {
                width: parent.width

                TextField {
                  id: time_input
                  text: tile_root.default_interval
                  validator: DoubleValidator { bottom: 0 }
                }

                Text {
                  text: tile_root.countdown.toFixed(3) + " sec"
                }
              }

              CommandControls {
                text: "START"
                armed: arming_controls.armed
                implicitHeight: childrenRect.height
                implicitWidth: parent.width
                onClicked: () => {
                  tile_root.countdown = time_input.text
                  tile_root.action.set_parameter("position", "open");
                  tile_root.action.execute();
                  tile_timer.start();
                  timer_animation.start();
                }
              }
            }

              Timer {
                id: tile_timer

                interval: time_input.text * 1000
                onTriggered: {
                  tile_root.action.set_parameter("position", "close");
                  tile_root.action.execute();
                }
              }

              NumberAnimation on countdown {
                id: timer_animation
                to: 0
                duration: tile_root.countdown*1000
              }
          }

          CommandTile {
            command: CommandAction { service: root.controller.commandService; command: "IGNITE" }
            width: actions_view.width
          }
          CommandPairTile {
            command: CommandAction {
              service: root.controller.commandService; command: "VALVE"
              Component.onCompleted: set_parameter("valve", "SV-N201");
            }
            name: "MAIN OX\nVALVE"
            implicitHeight: 110
            width: actions_view.width
          }
          CommandPairTile {
            command: CommandAction {
              service: root.controller.commandService
              command: "VALVE"
              Component.onCompleted: set_parameter("valve", "SV-E203");
            }
            name: "MAIN FUEL\nVALVE"
            implicitHeight: 110
            width: actions_view.width
          }
          CommandPairTile {
            command: CommandAction {
              service: root.controller.commandService
              command: "VALVE"
              Component.onCompleted: set_parameter("valve", "SV-N202");
            }
            name: "VENT VALVE"
            width: actions_view.width
          }
          CommandPairTile {
            command: CommandAction {
              service: root.controller.commandService;
              command: "VALVE";
              Component.onCompleted: set_parameter("valve", "SV-N101");
            }
            name: "FILL VALVE"
            width: actions_view.width
          }
          CommandPairTile {
            command: CommandAction {
              service: root.controller.commandService;
              command: "VALVE";
              Component.onCompleted: set_parameter("valve", "SV-N204");
            }
            name: "SOLENOID\nDUMP VALVE"
            implicitHeight: 110
            width: actions_view.width
          }
          CommandPairTile {
            command: CommandAction {
              service: root.controller.commandService;
              command: "VALVE";
              Component.onCompleted: set_parameter("valve", "SV-N102");
            }
            name: "REMOTE DUMP\nVALVE"
            implicitHeight: 110
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
            ListElement { name: "TANK\nPRESSURE"; topic: "telemetry/tank/pressure" }
            ListElement { name: "SUPPLY\nPRESSURE"; topic: "telemetry/supply/pressure" }
            ListElement { name: "CHAMBER\nPRESSURE"; topic: "telemetry/chamber/pressure" }
            ListElement { name: "VENT\nTEMPERATURE"; topic: "telemetry/tank/vent/temperature" }
            ListElement { name: "CHAMBER\nTEMPERATURE"; topic: "telemetry/chamber/temperature" }
            ListElement { name: "VOLTAGE"; topic: "telemetry/voltage" }
            ListElement { name: "CURRENT"; topic: "telemetry/current" }
            ListElement { name: "THRUST"; topic: "telemetry/thrust" }
            ListElement { name: "LOAD CELL 1"; topic: "telemetry/tank/weight/1" }
            ListElement { name: "LOAD CELL 2"; topic: "telemetry/tank/weight/2" }
            ListElement { name: "LOAD CELL 3"; topic: "telemetry/tank/weight/3" }
            ListElement { name: "LOAD CELL 4"; topic: "telemetry/tank/weight/4" }
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
