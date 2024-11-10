#ifndef ACTION_H
#define ACTION_H

#include <QtQml/qqml.h>

#include "command.h"
#include "commandservice.h"

namespace NCR {

class Action : public QObject {
  Q_OBJECT
  QML_INTERFACE
public:
  Action() = default;
  virtual ~Action() = default;

  Q_INVOKABLE virtual void execute() { }
};

class CommandAction : public Action {
  Q_OBJECT
  Q_PROPERTY(Command command READ command WRITE command NOTIFY commandChanged)
  QML_ELEMENT
public:
  CommandAction() =default;
  CommandAction(const Command& command, CommandService* service) : command_(command), service_(service) { }

  void execute() override {
    service_->send_command(command_);
  }

  Command& command() { return command_; }

  void command(const Command& command) {
    command_ = command;
    emit commandChanged();
  }

signals:
  void commandChanged();

private:
  CommandService* service_;
  Command command_;
};

}
#endif // ACTION_H
