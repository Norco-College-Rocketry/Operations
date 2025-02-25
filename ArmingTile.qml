import QtQuick
import QtQuick.Layouts

Tile {
  id: root

  property alias armed: arming_controls.armed
  property alias name: arming_controls.name

  radius: 4
  color: arming_controls.armed ? "#FAF4DA" : "#B3AE9B"

  ArmingControls {
    id: arming_controls
    anchors.fill: parent
    anchors.centerIn: parent
    anchors.margins: 5
  }
}
