#include "mqttcommandservice.h"

#include <spdlog/spdlog.h>
#include <QJsonObject>
#include <QJsonDocument>

using namespace NCR;

void MqttCommandService::send_command(const Command& command) {
  std::string msg;
  QJsonObject json, parameters;

  QString topic = topic_;
  json["command"] = QString::fromStdString(command.command());
  if (!command.parameters().empty()) {
    for (const auto& [name, value] : command.parameters()) {
      parameters.insert(QString::fromStdString(name), QString::fromStdString(value));
    }
    json["parameters"] = parameters;
  }
  msg = QJsonDocument(json).toJson(QJsonDocument::Compact);

  if (client_->publish(topic, QByteArray::fromStdString(msg)) == -1) {
    spdlog::error("Error publishing MQTT command: {}", msg);
  }
}

