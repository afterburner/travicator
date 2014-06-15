require "travicator"
require "travicator/verifier/base"
require "travicator/verifier/git/repo"

module Travicator::Verifier::Git
    class PrePush < Travicator::Verifier::Base
    def self.options
      { :directory => Dir.pwd }
    end

    def self.deps
      [ Travicator::Verifier::Git::Repo.class ]
    end

    def run
      raise "Verifier can only be run once" unless @state == Travicator::Verifier::UNKNOWN

      @state = Travicator::Verifier::RUNNING
      Dir.chdir(options[:directory]) do
        hooks = File.expand_path(`git rev-parse --show-cdup 2>&1`).sub(/\s+\Z/, "") + ".git/hooks"
        unless $?.success? && Dir.exist?(hooks)
          @state = Travicator::Verifier::FAILURE
          @error = "Something went wrong. Couldn't find the git hooks directory."
          return
        end

        prepush = hooks + "/pre-push"
        unless File.exist?(prepush)
          @state = Travicator::Verifier::FAILURE
          @error = "pre-push git-hook not installed."
          return
        end

        standard = Travicator.assets_dir + '/git-hooks/pre-push'
        unless FileUtils::cmp(prepush, standard)
          @state = Travicator::Verifier::FAILURE
          @error = "pre-push git-hook is not the same as travicator's version."
          return
        end
        @state = Travicator::Verifier::SUCCESS
      end
    end
  end
end
