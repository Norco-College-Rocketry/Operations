import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Item {
  id: root

  property alias armed: arm_switch.checked
  property alias name: name_label.text

  RowLayout {
    id: arming_controls_container

    uniformCellSizes: true

    Text {
      id: name_label
      Layout.fillWidth: true
      Layout.alignment: Qt.AlignHCenter
      text: name
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
