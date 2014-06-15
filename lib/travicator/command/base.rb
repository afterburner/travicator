class Travicator::Command::Base
  attr_reader :options

  def initialize(options={})
    @options = options
  end

  def command
    self.class.name.split('::').last.downcase
  end

  # Any subclass of this class is a command. Register it with the module.
  def self.inherited(subclass)
    Travicator::Command.register(subclass)
  end
end
