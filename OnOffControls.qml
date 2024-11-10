import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

ColumnLayout {
  id: root

  implicitHeight: childrenRect.height

  property string on_text: "On"
  property string off_text: "Off"
  property alias on_button: on_button
  property alias off_button: off_button
  property bool armed: false
  property bool on: false

 RowLayout {
   id: action_1_controls

   Layout.fillWidth: true
   Layout.fillHeight: true
   uniformCellSizes: true

   Button {
     id: on_button
     Layout.fillWidth: true
     text: "ON"
     enabled: root.armed
     onClicked: () => root.on = true;
   }
   Button {
     id: off_button
     Layout.fillWidth: true
     text: "OFF"
     enabled: root.armed
     onClicked: () => root.on = false;
   }
 }

 Item {
   implicitWidth: parent.width
   implicitHeight: childrenRect.height

   Text {
     id: indicator
     anchors.left: parent.left
     anchors.right: parent.right
     text: root.on ? root.on_text : root.off_text
     rightPadding: 5
     horizontalAlignment: Text.AlignHCenter
   }
 }
}
