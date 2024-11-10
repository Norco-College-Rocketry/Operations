#include "controller.h"

#include <spdlog/spdlog.h>

using namespace NCR;

void Controller::info(QString msg) {
  spdlog::info(msg.toStdString());
}
