import QtQuick
import QtQuick.Layouts

ArmingTile {
  id: root

  property alias open: on_off_controls.on

  implicitHeight: 100

  OnOffControls {
    id: on_off_controls
    armed: parent.armed
    implicitWidth: parent.width
  }
}
