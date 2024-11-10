#ifndef COMMAND_H
#define COMMAND_H

#include <string>
#include <unordered_map>

namespace NCR {

class Command
{
public:
  Command() =default;
  Command(std::string command) : command_(command) { }
  virtual ~Command() =default;

  void command(std::string command) noexcept { command_ = command; }
  void set_parameter(std::string name, std::string value) { params_[name] = value; }
  void remove_parameter(std::string name) {
    if (params_.count(name)) {
      params_.erase(name);
    }
  }

  std::string command() const noexcept { return command_; }
  std::unordered_map<std::string, std::string> paramteres() noexcept { return params_; }

private:
  std::string command_ = "";
  std::unordered_map<std::string, std::string> params_;
};

}

#endif // COMMAND_H
