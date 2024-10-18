import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

ColumnLayout {
  id: root

  implicitHeight: childrenRect.height

  property bool armed: false
  property bool open: false

 RowLayout {
   id: action_1_controls

   Layout.fillWidth: true
   Layout.fillHeight: true
   uniformCellSizes: true

   Button {
     Layout.fillWidth: true
     text: "ON"
     enabled: root.armed
     onClicked: () => root.open = true;
   }
   Button {
     Layout.fillWidth: true
     text: "OFF"
     enabled: root.armed
     onClicked: () => root.open = false;
   }
 }

 Item {
   implicitWidth: parent.width
   implicitHeight: childrenRect.height

   Text {
     anchors.left: parent.left
     anchors.right: parent.right
     text: root.open ? "Open" : "Closed"
     rightPadding: 5
     horizontalAlignment: Text.AlignHCenter
   }
 }
}
