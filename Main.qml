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
      MockActionTile {}

      Tile {
        implicitHeight: childrenRect.height
        implicitWidth: parent.width
        Rectangle { anchors.left: parent.left; anchors.top: parent.top; anchors.margins: 5; height: 100; width: 100; color: "lightyellow" }
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
