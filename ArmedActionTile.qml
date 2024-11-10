import QtQuick
import QtQuick.Layouts

Tile {
  id: root

  default property alias children: arming_controls.children
  property alias name: arming_controls.name

  radius: 4
  color: arming_controls.armed ? "#FAF4DA" : "#B3AE9B"

  ArmedAction {
    id: arming_controls
    anchors.fill: parent
    anchors.centerIn: parent
    anchors.margins: 5
  }
}
