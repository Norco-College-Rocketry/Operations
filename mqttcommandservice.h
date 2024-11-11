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
    Q_PROPERTY(QMap<QString, QString> *subtopics READ subtopics WRITE subtopics NOTIFY subtopicsChanged)
    Q_PROPERTY(CommandService *interface READ interface CONSTANT)
    QML_IMPLEMENTS_INTERFACES(NCR::CommandService)
  public:
    Q_INVOKABLE void send_command(const NCR::Command &command) override;

    CommandService *interface() { return this; }

    QmlMqttClient *client() noexcept { return client_; }

    QString topic() noexcept { return topic_; }

    QMap<QString, QString> *subtopics() noexcept { return subtopics_; }

    void subtopics(QMap<QString, QString> *subtopics) {
      subtopics_ = subtopics;
      emit subtopicsChanged();
    }

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
    QMap<QString, QString> *subtopics_ = new QMap<QString, QString>({
                                                                            {"FILL_VALVE",  "/valve/fill"},
                                                                            {"OX_VALVE",    "/valve/ox"},
                                                                            {"FUEL_VALVE",  "/valve/fuel"},
                                                                            {"PURGE_VALVE", "/valve/purge"}
                                                                    });

  };
}

#endif // MQTTCOMMANDSERVICE_H
