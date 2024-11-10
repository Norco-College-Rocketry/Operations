import QtQuick
import QtQuick.Layouts

Tile {
  id: root

  default property alias children: action.children
  property alias name: action.name

  implicitHeight: 100

  radius: 4
  color: action.armed ? "#FAF4DA" : "#B3AE9B"

  ArmedAction {
    id: action
    anchors.fill: parent
    anchors.centerIn: parent
    anchors.margins: 5
  }
}
