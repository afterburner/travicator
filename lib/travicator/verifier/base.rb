require "travicator/verifier"

class Travicator::Verifier::Base
  attr_reader :state, :error, :options

  def initialize(options={})
    @state = Travicator::Verifier::UNKNOWN
    @options = options
  end

  def self.deps
    []
  end

  def self.options
    {}
  end

  def self.description
    ""
  end
end
