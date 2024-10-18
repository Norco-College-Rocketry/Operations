import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

ColumnLayout {
  id: root

  property alias armed: arm_switch.checked

  RowLayout {
    id: arming_controls_container

    Layout.fillWidth: true
    uniformCellSizes: true

    Text {
      Layout.fillWidth: true
      Layout.alignment: Qt.AlignHCenter
      text: "ACTION 1"
      horizontalAlignment: Text.AlignHCenter
    }
    Switch {
      id: arm_switch
      Layout.fillWidth: true
      Layout.alignment: Qt.AlignRight
      text: checked ? "ARMED" : "SAFED"

      contentItem: Text {
        text: arm_switch.text
        color: "black"
        verticalAlignment: Text.AlignVCenter
        leftPadding: arm_switch.indicator.width + arm_switch.spacing
      }
    }
  }
}
