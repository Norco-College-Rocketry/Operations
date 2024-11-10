#include "controller.h"

#include <spdlog/spdlog.h>

using namespace NCR;

void Controller::info(QString msg) {
  spdlog::info(msg.toStdString());
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
