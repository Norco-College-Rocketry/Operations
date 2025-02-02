#ifndef MQTTCOMMANDSERVICE_H
#define MQTTCOMMANDSERVICE_H

#include "commandservice.h"
#include "qmlmqttclient.h"

namespace NCR {

  class MqttCommandService : public QObject, public CommandService {
  Q_OBJECT

    QML_ELEMENT
    Q_PROPERTY(QmlMqttClient *client READ client WRITE client NOTIFY clientChanged)
    Q_PROPERTY(QString topic READ topic WRITE topic NOTIFY topicChanged)
    Q_PROPERTY(CommandService *interface READ interface CONSTANT)
    QML_IMPLEMENTS_INTERFACES(NCR::CommandService)
  public:
    Q_INVOKABLE void send_command(const NCR::Command &command) override;

    CommandService *interface() { return this; }

    QmlMqttClient *client() noexcept { return client_; }

    QString topic() noexcept { return topic_; }

    void client(QmlMqttClient *client) noexcept {
      client_ = client;
      emit clientChanged();
    }

    void topic(QString topic) noexcept {
      topic_ = topic;
      emit topicChanged();
    }

  signals:

    void clientChanged();

    void topicChanged();

    void subtopicsChanged();

  private:
    QmlMqttClient *client_;
    QString topic_;
  };
}

#endif // MQTTCOMMANDSERVICE_H
