
#include <gmock/gmock-matchers.h>
#include <gtest/gtest.h>
#include "../controller.h"
#include "../commandservice.h"
#include "../action.h"

using namespace testing;

class MockCommandService : public NCR::CommandService {
public:
  void send_command(const NCR::Command& command) override {
    received_commands.push_back(command);
  }
  std::vector<NCR::Command> received_commands;
};

//TEST (CommandingTests, MqttCommandTest)
//{
//  EXPECT_EQ (1, 1);
//  ASSERT_THAT (0, Eq (0));
//}

TEST (CommandingTests, CommandActionTest) {
  MockCommandService service;
  NCR::Command command;
  command.command("TEST");
  NCR::CommandAction action(command, &service);

  action.execute();

  EXPECT_THAT(service.received_commands.size(), Eq (1));
  ASSERT_THAT(service.received_commands[0].command(), Eq (command.command()));
}

//TEST (CommandingTests, ControllerCreateSequence)
//{
//  NCR::Controller controller;
//  QList<NCR::Actions> sequence = {TEST_ACTION_1, TEST_ACTION_2};
//  controller.create_sequence("TEST_SEQUENCE", sequence);
//}
//
//TEST (CommandingTests, ActionRegistryTest)
//{
//  bool did_run_1 = false, did_run_2 = false;
//  auto action = [&](){ did_run_1 = true; };
//  auto action2 = [&](){ did_run_2 = true; };
//  auto sequence = [&](){ action(); action2(); };
//  ActionRegistry registry;
//  registry.register(sequence);
//
//}
