import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Window {
  width: 480
  height: 800
  visible: true
  title: qsTr("GSC Operations Application - Norco College Rocketry")

  GridLayout {
    anchors.fill: parent
    columns: 2
    anchors.margins: 5

    Flickable {
      id: actions_container
      Layout.preferredWidth: 50
      Layout.fillWidth: true
      Layout.fillHeight: true

      ObjectModel {
        id: action_model

        MockActionTile {}
        MockActionTile {}
        MockActionTile {}
        MockActionTile {}
        MockActionTile {}
        MockActionTile {}
        MockActionTile {
          id: tile
          implicitHeight: 120
          RowLayout {
            id: timer

            property int countdown: 5000

            Layout.fillWidth: true

            Text {
              id: label

              Layout.fillWidth: true
              text: (timer.countdown/1000).toFixed(3) + " s"
              font.family: "Source Code Pro"
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
        anchors.fill: parent

        spacing: 5
        model: action_model
      }
    }

    Rectangle {
      id: readout_container

      Layout.preferredWidth: 50
      Layout.fillWidth: true
      Layout.fillHeight: true

      color: "gray"
      border.color: "black"
      border.width: 1

      Flickable {
        anchors.fill: parent
        anchors.margins: 5

        clip: true

        ListModel {
          id: list_model
          ListElement { name: "Fuel Pressure"; value: "759 psi" }
          ListElement { name: "Oxidizer Pressure"; value: "802 psi" }
          ListElement { name: "Tank Temp "; value: "18 \u00b0C" }
          ListElement { name: "Combustion Pressure"; value: "298 psi" }
          ListElement { name: "Combustion Temp"; value: "3109\u00b0C" }
        }

        ListView {
          id: list_view

          anchors.fill: parent
          anchors.margins: 5

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
