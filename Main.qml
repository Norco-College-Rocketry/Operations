import QtQuick
import QtQuick.Layouts

Window {
  id: root

  MqttCommandService {
    id: mqtt_command_service
    client: controller.mqtt
    topic: controller.settings.value("mqtt/command_topic", "commands")
  }

  Controller {
    id: controller

    mqtt: MqttClient {
      hostname: controller.settings.value("mqtt/hostname", "localhost")
      port: controller.settings.value("mqtt/port", 1883)
    }
    commandService: mqtt_command_service.interface
    settings: QSettings { }
  }

  Component.onCompleted: {
    controller.mqtt.connectToHost();
    controller.initialize_settings(controller.settings);
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

      radius: 5
      color: "#FAF4DA"

      Flickable {
        anchors.fill: parent
        anchors.margins: 5

        ObjectModel {
          id: action_model
          CommandTile {
            action: CommandAction { service: controller.commandService }
            name: "ABORT"
            command: "ABORT"
            text: "ABORT"
            width: actions_view.width
          }
          CommandPairTile {
            action: CommandAction { service: controller.commandService }
            name: "FILL VALVE"
            command: "FILL_VALVE"
            width: actions_view.width
          }
          CommandPairTile {
            action: CommandAction { service: controller.commandService }
            name: "OX VALVE"
            command: "OX_VALVE"
            width: actions_view.width
          }
          CommandPairTile {
            action: CommandAction { service: controller.commandService }
            name: "FUEL VALVE"
            command: "FUEL_VALVE"
            width: actions_view.width
          }
          CommandPairTile {
            action: CommandAction { service: controller.commandService }
            name: "PURGE VALVE"
            command: "PURGE_VALVE"
            width: actions_view.width
          }
          CommandTile {
            action: CommandAction { service: controller.commandService }
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
      // color: "#DDDECE"
      color: "#FAF4DA"
      border.color: "black"
      border.width: 1

      Flickable {
        anchors.fill: parent
        anchors.margins: 5

        clip: true

        ListModel {
          id: list_model
          ListElement { name: "TANK PRESSURE"; topic: "pressure/tank"; units: "psi" }
          ListElement { name: "INJECTOR PRESSURE"; topic: "pressure/injector"; units: "psi" }
          ListElement { name: "FEED PRESSURE"; topic: "pressure/feed"; units: "psi" }
          ListElement { name: "INJECTOR TEMP"; topic: "temperature/injector"; units: "\u00b0C" }
          ListElement { name: "VENT TEMP"; topic: "temperature/vent"; units: "\u00b0C" }
          ListElement { name: "CC TEMP"; topic: "temperature/chamber"; units: "\u00b0C" }
          ListElement { name: "LOAD CELL 1"; topic: "load_cell/1"; units: "g" }
          ListElement { name: "LOAD CELL 2"; topic: "load_cell/2"; units: "g" }
          ListElement { name: "SINE WAVE"; topic: "telemetry/sinewave"; units: "" }
        }

        ListView {
          id: list_view

          anchors.fill: parent

          spacing: 5
          model: list_model
          clip: true
          delegate: Rectangle {
            height: childrenRect.height+10
            width: ListView.view.width

            border.color: "black"
            border.width: 1

            property string value: "NC"

            Component.onCompleted: {
              controller.mqtt.stateChanged.connect(() => {
                if (controller.mqtt.state == 2) {
                  controller.mqtt.subscribe(topic)
                    .messageReceived.connect((message) => {
                      let val = JSON.parse(message)["value"]?.concat(" ", units) ?? message;
                      value = val;
                  });
                }
              });
            }

            RowLayout {
              height: 20
              width: parent.width

              Text {
                Layout.fillWidth: true
                Layout.margins: 5
                text: name
              }
              Text {
                Layout.fillWidth: true
                Layout.margins: 5
                horizontalAlignment: Text.AlignRight
                text: value
              }
            }
          }
        }
      }
    }
  }
}
