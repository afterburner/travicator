require "travicator/verifier/base"

require "json"

module Travicator::Verifier::Arc
  class ProperConfig < Travicator::Verifier::Base
    def self.options
      { :directory => Dir.pwd,
        :config => (Travicator.config rescue nil) }
    end

    def self.deps
      [ Travicator::Verifier::Arc::ArcConfig ]
    end

    def self.description
      "[ arc ] Verifying .arcconfig"
    end

    def run
      raise "Verifier can only be run once" unless @state == Travicator::Verifier::UNKNOWN

      unless options[:config]
        @state = Travicator::Verifier::FAILURE
        @error = "Couldn't find a .travicator.yml"
        return
      end

      @state = Travicator::Verifier::RUNNING
      # Check if options[:directory] contains an .arcconfig with the proper
      # configuration values.
      filename = options[:directory] + '/.arcconfig'
      begin
        hash = JSON.parse(IO.read(filename))
      rescue
        @state = Travicator::Verifier::FAILURE
        @error = "Looks like your .arcconfig is not valid JSON."
        return
      end

      unless hash["phabricator.uri"] == options[:config]["phabricator.uri"]
        @state = Travicator::Verifier::FAILURE
        @error = "phabricator.uri setting in .arcconfig doesn't match travicator config: expected #{options[:config][:phabricator_uri]} instead of #{hash["phabricator.uri"]}."
        return
      end

      unless hash["arcanist_configuration"] == "TravicatorArcanistConfiguration"
        @state = Travicator::Verifier::FAILURE
        @error = "arcanist_configuration setting in .arcconfig doesn't specify the proper php class config: expected TravicatorArcanistConfiguration instead of #{hash["arcanist_configuration"]}."
        return
      end
      
      @state = Travicator::Verifier::SUCCESS
    end
  end
end
