#include "mqttcommandservice.h"

#include <spdlog/spdlog.h>
#include <QJsonObject>
#include <QJsonDocument>

using namespace NCR;

void MqttCommandService::send_command(const Command& command) {
  std::string msg;

  QString topic = topic_;
  if (subtopics_->contains(QString::fromStdString(command.command()))) {
    topic += (*subtopics_)[QString::fromStdString(command.command())];

    QJsonObject json;
    for (const auto& [name, value] : command.parameters()) {
      json[QString::fromStdString(name)] = QString::fromStdString(value);
    }
    msg = QJsonDocument(json).toJson(QJsonDocument::Compact);
  } else {
    msg = command.command();
  }


  if (client_->publish(topic, QByteArray::fromStdString(msg)) == -1) {
    spdlog::error("Error publishing MQTT message: {}", msg);
  }
}

