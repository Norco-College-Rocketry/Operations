#ifndef COMMAND_H
#define COMMAND_H

#include <string>
#include <vector>

namespace NCR {

class Command
{
public:
  virtual ~Command() =default;

  void set_command(std::string command) noexcept { command_ = command; }
  std::string get_command() noexcept { return command_; }
  std::vector<std::string> get_params() noexcept { return params_; }

private:
  std::string command_ = "";
  std::vector<std::string> params_;
};

}

#endif // COMMAND_H
