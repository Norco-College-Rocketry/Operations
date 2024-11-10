#include "controller.h"

#include <spdlog/spdlog.h>

using namespace NCR;

void Controller::info(QString msg) {
  spdlog::info(msg.toStdString());
}

CommandAction* Controller::create_command_action(const QString& command, const QMap<QString, QString>& parameters) {
  if (!command_service_) {
    spdlog::error("Attempted to create command action while command service reference is null.");
    return nullptr;
  }

  Command c(command.toStdString());
  std::unordered_map<std::string, std::string> p;
  for (const auto [name, value] : parameters.asKeyValueRange()) {
    c.set_parameter(name.toStdString(), value.toStdString());
  }
  CommandAction* action = new CommandAction(c, command_service_);
  return action;
}

void Controller::onMqttStateChanged() {
  std::string str;
  switch (mqtt_->state()) {
    case QMqttClient::ClientState::Connected: { str = "Connected"; break; }
    case QMqttClient::ClientState::Connecting: { str = "Connecting"; break; }
    case QMqttClient::ClientState::Disconnected: { str = "Disconnected"; break; }
  }

  spdlog::info("MQTT state changed: {}",str);
}

void Controller::onMqttErrorChanged() {
  spdlog::error("MQTT error: {}",static_cast<int>(mqtt_->error()));
}
