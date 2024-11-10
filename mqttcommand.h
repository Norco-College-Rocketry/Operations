#ifndef MQTTCOMMAND_H
#define MQTTCOMMAND_H

#include "command.h"

#include <string>

namespace NCR {

class MqttCommand : public Command
{
public:
  MqttCommand() =default;
  MqttCommand(std::string topic, std::string value = "") : topic_(topic), value_(value) {}

  void set_value(std::string value) { value_ = value; }

private:
  std::string topic_ = "";
  std::string value_ = "";
};

}

#endif // MQTTCOMMAND_H
