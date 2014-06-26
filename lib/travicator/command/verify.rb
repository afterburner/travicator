require 'travicator/command/base'
require 'travicator/util/hash'

require 'travicator/verifier/arc/arcconfig'
require 'travicator/verifier/arc/properconfig'
require 'travicator/verifier/git/prepush'
require 'travicator/verifier/git/repo'

class Travicator::Command::Verify < Travicator::Command::Base
  def run
    # Manually list the verifiers for now. In the future, we should generate
    # this list based on subclasses of Travicator::Verifier.
    verifiers = [
      Travicator::Verifier::Arc::ArcConfig,
      Travicator::Verifier::Arc::ProperConfig,
      Travicator::Verifier::Git::PrePush,
      Travicator::Verifier::Git::Repo,
    ]

    # Topological sort of verifiers.
    dependency_graph = {}
    verifiers.each { |vklass| dependency_graph[vklass] = vklass.deps() }
    sorted = dependency_graph.tsort()

    successes = []

    sorted.each { |vklass|
      print vklass.description, "..."
      unless (vklass.deps() - successes).empty?
        print "SKIPPED\n"
        next
      end

      v = vklass.new(vklass.options)
      v.run
      case v.state
      when Travicator::Verifier::FAILURE
        print "FAILED: #{v.error}\n"
      when Travicator::Verifier::SUCCESS
        successes << vklass
        print "OK\n"
      else
        print "UNKNOWN\n"
      end
    }
  end

  def self.help
    "check the current repo for proper configuration"
  end
end
