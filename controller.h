#ifndef CONTROLLER_H
#define CONTROLLER_H

#include <QObject>
#include <QtQml/qqml.h>

#include "qmlmqttclient.h"
#include "commandservice.h"
#include "action.h"

namespace NCR {

class Controller : public QObject
{
  Q_OBJECT
  Q_PROPERTY(QmlMqttClient* mqtt READ mqtt WRITE mqtt NOTIFY mqttChanged REQUIRED)
  Q_PROPERTY(NCR::CommandService* commandService READ commandService WRITE commandService NOTIFY commandServiceChanged REQUIRED)
  QML_ELEMENT
public:
  explicit Controller (QObject *parent = nullptr) : QObject(parent) { }

  Q_INVOKABLE void info(QString msg);
  Q_INVOKABLE void debug(QString msg) { }
  Q_INVOKABLE void error(QString msg) { }
  Q_INVOKABLE void warn(QString msg) { }

  Q_INVOKABLE NCR::CommandAction* create_command_action(const QString& command = "", const QMap<QString, QString>& parameters = QMap<QString, QString>());

  QmlMqttClient* mqtt() { return mqtt_; }
  CommandService* commandService() { return command_service_; }

  void commandService(CommandService* command_service) {
    command_service_ = command_service;
    emit commandServiceChanged();
  }
  void mqtt(QmlMqttClient* mqtt) {
    mqtt_ = mqtt;
    QObject::connect(mqtt_, &QmlMqttClient::stateChanged, this, &Controller::onMqttStateChanged);
    QObject::connect(mqtt_, &QmlMqttClient::errorChanged, this, &Controller::onMqttErrorChanged);
    emit mqttChanged();
  }

signals:
  void mqttChanged();
  void commandServiceChanged();

public slots:
  void onMqttStateChanged();
  void onMqttErrorChanged();

private:
  QmlMqttClient* mqtt_ = nullptr;
  CommandService* command_service_ = nullptr;
};

}
#endif // CONTROLLER_H
