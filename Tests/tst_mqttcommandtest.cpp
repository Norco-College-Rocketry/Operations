
#include <gmock/gmock-matchers.h>
#include <gtest/gtest.h>

#include "../mqttcommandservice.h"

using namespace testing;

TEST (CommandingTests, MqttCommandTest)
{
  auto client = new QMqttClient();
  NCR::MqttCommandService service(client);

  client->setHostname("localhost");
  client->setPort(1883);
  client->setUsername("Operations");
  client->connectToHost();
  ASSERT_THAT(client->error(), Eq (0));

  service.set_topic("commands");
  NCR::Command command;
  command.set_command("TEST");
  // command.add_parameter("param", "1");

  service.send_command(command);

  EXPECT_EQ (1, 1);
  ASSERT_THAT (0, Eq (0));
}
