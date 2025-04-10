import QtQuick
import QtQuick.Controls

Item {
  id: root

  required property var onClicked
  property alias armed: button.enabled
  property alias text: button.text

  Button {
    id: button
    implicitWidth: parent.width
    text: "SEND COMMAND"
    onClicked: { root.onClicked(); }
  }
}
