require 'travicator/command/base'
class Travicator::Command::Help < Travicator::Command::Base
  def run
    puts "Running #{self.command} with options #{self.options}"
  end
end
