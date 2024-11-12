import QtQuick

Rectangle {
  id: root

  property alias color: indicator.color
  property alias text: label.text

  border.color: "black"
  border.width: 1

  Column {
    anchors.fill: parent
    anchors.centerIn: parent
    anchors.margins: 5

    Rectangle {
      id: indicator

      anchors.horizontalCenter: parent.horizontalCenter
      implicitWidth: 20
      implicitHeight: 20
      radius: 10
      color: "red"
    }

    Text {
      id: label
      anchors.horizontalCenter: parent.horizontalCenter
      text: "STATUS"
    }
  }
}
