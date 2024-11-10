
#include <gmock/gmock-matchers.h>
#include <gtest/gtest.h>

#include "../mqttcommandservice.h"

using namespace testing;

TEST (CommandingTests, MqttCommandTest)
{
  EXPECT_EQ (1, 1);
  ASSERT_THAT (0, Eq (0));
}
