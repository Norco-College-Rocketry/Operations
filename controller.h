#ifndef CONTROLLER_H
#define CONTROLLER_H

#include <QObject>
#include <QtQml/qqml.h>

#include "qmlmqttclient.h"

namespace NCR {

class Controller : public QObject
{
  Q_OBJECT
  Q_PROPERTY(QmlMqttClient* mqtt READ mqtt WRITE mqtt NOTIFY mqttChanged REQUIRED)
  QML_ELEMENT
public:
  explicit Controller (QObject *parent = nullptr) : QObject(parent) { }

  Q_INVOKABLE void info(QString msg);
  Q_INVOKABLE void debug(QString msg) { }
  Q_INVOKABLE void error(QString msg) { }
  Q_INVOKABLE void warn(QString msg) { }

  QmlMqttClient* mqtt() { return mqtt_; }
  void mqtt(QmlMqttClient* mqtt) {
    mqtt_ = mqtt;
    QObject::connect(mqtt_, &QmlMqttClient::stateChanged, this, &Controller::onMqttStateChanged);
  }

signals:
  void mqttChanged();

public slots:
  void onMqttStateChanged();

private:
  QmlMqttClient* mqtt_ = nullptr;
};

}
#endif // CONTROLLER_H
