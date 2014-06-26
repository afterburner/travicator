require "travicator/verifier/base"

module Travicator::Verifier::Git
  class Repo < Travicator::Verifier::Base
    def self.options
      { :directory => Dir.pwd }
    end

    def self.description
      "[ git ] Checking for valid git repo"
    end

    def run
      raise "Verifier can only be run once" unless @state == Travicator::Verifier::UNKNOWN

      @state = Travicator::Verifier::RUNNING
      # Check if options[:directory] is in a git repo.
      Dir.chdir(options[:directory]) do
        output = `git rev-parse --is-inside-work-tree 2>&1`
        if $?.success?
          @state = Travicator::Verifier::SUCCESS
        else
          @state = Travicator::Verifier::FAILURE
          @error = "This doesn't look like a git repo. You have to run travicator from within an existing git repo."
        end
      end
    end
  end
end
