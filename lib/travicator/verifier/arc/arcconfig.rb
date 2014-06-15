require "travicator/verifier/base"

require "json"

module Travicator::Verifier::Arc
  class ArcConfig < Travicator::Verifier::Base
    def self.options
      { :directory => Dir.pwd }
    end

    def run
      raise "Verifier can only be run once" unless @state == Travicator::Verifier::UNKNOWN

      @state = Travicator::Verifier::RUNNING
      # Check if options[:directory] contains an .arcconfig and it's valid json.
      filename = options[:directory] + '/.arcconfig'
      unless File.exist?(filename)
        @state = Travicator::Verifier::FAILURE
        @error = "Looks like your .arcconfig is missing."
        return
      end

      begin
        hash = JSON.parse(IO.read(filename))
      rescue
        @state = Travicator::Verifier::FAILURE
        @error = "Looks like your .arcconfig is not valid JSON."
        return
      end
      @state = Travicator::Verifier::SUCCESS
    end
  end
end
