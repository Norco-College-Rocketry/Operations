#ifndef COMMANDSERVICE_H
#define COMMANDSERVICE_H

#include "command.h"

namespace NCR {

class CommandService
{
public:
  virtual ~CommandService() =default;

  virtual void send_command(Command command) =0;
};

}

#endif // COMMANDSERVICE_H
