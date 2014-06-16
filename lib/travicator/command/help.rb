require 'travicator'
require 'travicator/command/base'

class Travicator::Command::Help < Travicator::Command::Base
  def run
    puts "Usage: travicator COMMAND\n\n"

    puts "Available commands:\n"
    commands = Travicator::Command.commands.sort_by { |cmd, klass| cmd }

    for cmd, klass in commands
      puts "    #{cmd.ljust(12)} #{klass.help}\n"
    end
  end

  def self.help
    "display this help message"
  end
end
