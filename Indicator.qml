import QtQuick
import QtQuick.Layouts

Rectangle {
  id: root

  property string topic: ""
  property string name: "Indicator"
  property string value: "N/C"

  border.color: "black"
  border.width: 1

  RowLayout {
    anchors.margins: 5
    anchors.fill: parent
    anchors.centerIn: parent

    Text {
      Layout.fillWidth: true
      verticalAlignment: Text.AlignVCenter
      text: name
    }
    Text {
      Layout.fillWidth: true
      verticalAlignment: Text.AlignVCenter
      horizontalAlignment: Text.AlignRight
      text: value
    }
  }
}