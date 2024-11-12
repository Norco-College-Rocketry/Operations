#include "controller.h"

#include <spdlog/spdlog.h>

using namespace NCR;

void Controller::info(QString msg) { spdlog::info(msg.toStdString()); }
void Controller::debug(QString msg) { spdlog::debug(msg.toStdString()); }
void Controller::error(QString msg) { spdlog::error(msg.toStdString()); }
void Controller::warn(QString msg) { spdlog::warn(msg.toStdString()); }

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
    case QMqttClient::ClientState::Connected: { str = "connected"; break; }
    case QMqttClient::ClientState::Connecting: { str = "connecting"; break; }
    case QMqttClient::ClientState::Disconnected: { str = "disconnected"; break; }
  }

  spdlog::debug("MQTT {}",str);
}

void Controller::onMqttErrorChanged() {
  spdlog::error("MQTT error: {}",static_cast<int>(mqtt_->error()));
}
