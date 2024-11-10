// Copyright (C) 2018 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

#ifndef QMLMQTTCLIENT_H
#define QMLMQTTCLIENT_H

#include <QtCore/QMap>
#include <QtMqtt/QMqttClient>

#include <QtQml/qqml.h>

class QmlMqttClient : public QObject
{
  Q_OBJECT
  Q_PROPERTY(QString hostname READ hostname WRITE setHostname NOTIFY hostnameChanged)
  Q_PROPERTY(int port READ port WRITE setPort NOTIFY portChanged)
  Q_PROPERTY(QMqttClient::ClientState state READ state WRITE setState NOTIFY stateChanged)
  Q_PROPERTY(QMqttClient::ClientError error READ error NOTIFY errorChanged)
  QML_NAMED_ELEMENT(MqttClient)
  QML_EXTENDED_NAMESPACE(QMqttClient)
public:

  QmlMqttClient(QObject *parent = nullptr);

  Q_INVOKABLE void connectToHost();
  Q_INVOKABLE void disconnectFromHost();
  Q_INVOKABLE int publish(const QString &topic, const QString &message, int qos = 0, bool retain = false);

  const QString hostname() const;
  void setHostname(const QString &newHostname);

  int port() const;
  void setPort(int newPort);

  const QMqttClient::ClientState state() const;
  void setState(const QMqttClient::ClientState &newState);

  const QMqttClient::ClientError error() const;

signals:
  void hostnameChanged();
  void portChanged();

  void stateChanged();
  void errorChanged();

private:
  Q_DISABLE_COPY(QmlMqttClient)
  QMqttClient m_client;
};

#endif // QMLMQTTCLIENT_H
