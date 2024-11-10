#include "mqttcommandservice.h"

#include <spdlog/spdlog.h>

using namespace NCR;

void MqttCommandService::send_command(const Command& command) {
  std::string msg = command.command();
    if (client_->publish(topic_, QByteArray::fromStdString(msg)) == -1) {
      spdlog::error("Error publishing MQTT message: {}", msg);
  }
}

