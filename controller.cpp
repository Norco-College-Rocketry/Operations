#include "controller.h"

#include <spdlog/spdlog.h>

using namespace NCR;

void Controller::info(QString msg) {
  spdlog::info(msg.toStdString());
}

void Controller::initialize_settings(QmlQSettings* settings) {
  settings->beginGroup("mqtt");
  if (!settings->contains("hostname")) { settings->setValue("hostname", "localhost"); }
  if (!settings->contains("port")) { settings->setValue("port", 1883); }
  if (!settings->contains("command_topic")) { settings->setValue("command_topic", "commands"); }
  if (!settings->contains("telemetry_topic")) { settings->setValue("telemetry_topic", "telemetry"); }
  settings->endGroup();
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
