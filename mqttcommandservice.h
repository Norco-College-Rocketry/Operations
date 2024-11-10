#ifndef MQTTCOMMANDSERVICE_H
#define MQTTCOMMANDSERVICE_H

#include <iostream>

#include "commandservice.h"
#include "mqttcommand.h"

#include <QtMqtt/QMqttClient>

namespace NCR {

class MqttCommandService : public CommandService, public QObject
{
public:
  MqttCommandService(QMqttClient* client) : client_(client), CommandService() {
    QObject::connect(client_, &QMqttClient::messageReceived, this, [this](const QByteArray &message, const QMqttTopicName &topic) {
      std::cout << topic.name().toStdString() << ' ' << message.toStdString() << std::endl;
    });
    QObject::connect(client_, &QMqttClient::stateChanged, this, &NCR::MqttCommandService::state_changed);
    QObject::connect(client_, &QMqttClient::errorChanged, this, &NCR::MqttCommandService::error_changed);
    QObject::connect(client_, &QMqttClient::connected, this, &NCR::MqttCommandService::send);
    client_->connectToHost();
  }

  void send_command(Command command) override {
    if (client_->state() == QMqttClient::Disconnected) {
        client_->connectToHost();
    }

    std::string msg = command.get_command();
    for (const auto& param : command.get_params()) {
      msg += param;
    }

    if (client_->publish(topic_, QByteArray::fromStdString(msg)) == -1) {
        std::cout << "Error publishing\n";
      }
  }

  QMqttClient* get_client() noexcept { return client_;}
  void set_client(QMqttClient* client) noexcept { client_ = client; }

  void set_topic(std::string topic) noexcept {
    topic_.setName(QString::fromStdString(topic));
  }

public slots:
  void error_changed(QMqttClient::ClientError error) {
    std::cout << "Mqtt client error: " << error << std::endl;
  }

  void state_changed(QMqttClient::ClientState state) {
    std::cout << "New state " << state << std::endl;
  }

  void send() {
    std::cout << "Connected\n";
    auto topic = QMqttTopicName("commands");
    client_->publish(topic, "TEST");
  }

private:
  QMqttTopicName topic_;
  QMqttClient* client_;
};

}

#endif // MQTTCOMMANDSERVICE_H
