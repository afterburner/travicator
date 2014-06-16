require 'travicator/version'
require 'travicator/command/base'

class Travicator::Command::Version < Travicator::Command::Base
  def run
    puts Travicator::VERSION
  end
end
