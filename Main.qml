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

    Column {
      id: actions_container
      Layout.preferredWidth: 50
      Layout.fillWidth: true
      Layout.fillHeight: true
      Layout.margins: 5
      spacing: 5

      MockActionTile {}
      MockActionTile {}
      MockActionTile {
        id: tile
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

      Tile {
        implicitHeight: childrenRect.height
        implicitWidth: parent.width
        Rectangle { height: 100; width: parent.width; color: "lightblue" }
      }
    }

    Item {
      id: readout_container

      Layout.preferredWidth: 50
      Layout.fillWidth: true
      Layout.fillHeight: true
      Layout.margins: 5

      Rectangle {
        anchors.fill: parent
        color: "pink"
      }

      Flickable { }
    }
  }
}
