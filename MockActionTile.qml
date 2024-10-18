import QtQuick

Tile {
  id: root

  implicitWidth: parent.width
  implicitHeight: childrenRect.height + 10

  ArmedAction {
    implicitWidth: parent.width - 10
    implicitHeight: childrenRect.height

    anchors.centerIn: parent
    anchors.margins: 5

    OnOffControls {
      armed: parent.armed
      implicitWidth: parent.width
    }
  }
}
