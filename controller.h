#ifndef CONTROLLER_H
#define CONTROLLER_H

#include <QObject>
#include <QtQml/qqml.h>

#include "qmlmqttclient.h"

namespace NCR {

class Controller : public QObject
{
  Q_OBJECT
  Q_PROPERTY(QmlMqttClient* mqtt READ mqtt CONSTANT)
  QML_ELEMENT
public:
  explicit Controller (QObject *parent = nullptr);

  Q_INVOKABLE void info(QString msg);
  Q_INVOKABLE void debug(QString msg) { }
  Q_INVOKABLE void error(QString msg) { }
  Q_INVOKABLE void warn(QString msg) { }

  QmlMqttClient* mqtt() { return mqtt_; }

public slots:
  void onMqttStateChanged();

private:
  QmlMqttClient* mqtt_;
};

}
#endif // CONTROLLER_H
