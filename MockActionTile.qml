import QtQuick
import QtQuick.Layouts

Tile {
  id: root

  default property alias children: action.children
  property alias open: on_off_controls.open
  property alias name: action.name

  implicitHeight: 100

  color: on_off_controls.armed ? "lightgray" : "darkgray"

  ArmedAction {
    id: action
    anchors.fill: parent
    anchors.centerIn: parent
    anchors.margins: 5

    OnOffControls {
      id: on_off_controls
      armed: parent.armed
      implicitWidth: parent.width
    }
  }
}
