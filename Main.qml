import QtQuick
import QtQuick.Layouts

Window {
  id: root

  Controller {
    id: controller

    mqtt: MqttClient {
      hostname: "localhost"
      port: 1883
    }
  }

  Component.onCompleted: {
    controller.mqtt.connectToHost();
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
          CommandTestTile { mqtt: controller.mqtt; width: actions_view.width }
          MockActionTile { name: "ACTION 1"; width: actions_view.width }
          MockActionTile { name: "ACTION 2"; width: actions_view.width }
          MockActionTile { name: "ACTION 3"; width: actions_view.width }
          MockActionTile { name: "ACTION 4"; width: actions_view.width }
          MockActionTile { name: "ACTION 5"; width: actions_view.width }
          // Mock timed sequence
          MockActionTile {
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
          ListElement { name: "FUEL PRESSURE"; value: "759 psi" }
          ListElement { name: "OX PRESSURE"; value: "802 psi" }
          ListElement { name: "TANK TEMP"; value: "18 \u00b0C" }
          ListElement { name: "CC PRESSURE"; value: "298 psi" }
          ListElement { name: "CC TEMP"; value: "3109\u00b0C" }
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
