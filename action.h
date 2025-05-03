#ifndef ACTION_H
#define ACTION_H

#include <QtQml/qqml.h>

#include "command.h"
#include "commandservice.h"

namespace NCR {
class Action {
  QML_INTERFACE
public:
  Action() = default;

  virtual ~Action() = default;

  Q_INVOKABLE virtual void execute() = 0;
};
}
  Q_DECLARE_INTERFACE(NCR::Action, "Action")

namespace NCR {
class CommandAction : public QObject, public Action {
  Q_OBJECT
  Q_PROPERTY(CommandService* service READ service WRITE service NOTIFY serviceChanged)
  Q_PROPERTY(QString command READ get_command WRITE set_command NOTIFY commandChanged)
  QML_ELEMENT
  QML_IMPLEMENTS_INTERFACES(NCR::Action)
public:
  CommandAction() =default;
  CommandAction(const Command& command, CommandService* service) : command_(command), service_(service) { }
  CommandAction(const QString& command, CommandService* service) : service_(service) { set_command(command); }

  Q_INVOKABLE void execute() override {
    service_->send_command(command_);
  }

  Q_INVOKABLE void set_command(const QString& command) { command_.command(command.toStdString()); }
  Q_INVOKABLE void set_parameter(const QString& name, const QString& value) {
    command_.set_parameter(name.toStdString(), value.toStdString());
  }
  Q_INVOKABLE void remove_parameter(const QString& name) { command_.remove_parameter(name.toStdString()); }

  CommandService* service() { return service_; }
  Command& command() { return command_; }
  Q_INVOKABLE QString get_command() { return QString::fromStdString(command_.command()); }

  void service(CommandService* service) {
    service_ = service;
    emit serviceChanged();
  }
  void command(const Command& command) {
    command_ = command;
    emit commandChanged();
  }

signals:
  void commandChanged();
  void serviceChanged();

private:
  CommandService* service_;
  Command command_;
};
}

#endif // ACTION_H
