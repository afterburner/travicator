class Travicator::Verifier::Base
  attr_reader :state

  def init
    @state = Verifier::UNKNOWN
  end
end
