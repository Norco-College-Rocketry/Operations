#ifndef COMMANDSERVICE_H
#define COMMANDSERVICE_H

#include "command.h"

#include <QtQml/qqml.h>

namespace NCR {

class CommandService
{
  QML_INTERFACE
public:
  virtual ~CommandService() =default;

  virtual void send_command(const NCR::Command& command) =0;
};

}

Q_DECLARE_INTERFACE(NCR::CommandService, "CommandService");

#endif // COMMANDSERVICE_H
