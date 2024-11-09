#ifndef MQTTCOMMANDSERVICE_H
#define MQTTCOMMANDSERVICE_H

#include "commandservice.h"

namespace NCR {

class MqttCommandService : public CommandService
{
public:
  void send_command(Command command) override {}
};

}

#endif // MQTTCOMMANDSERVICE_H
