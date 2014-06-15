$:.unshift File.expand_path("../lib", __FILE__)

require "travicator/version"

Gem::Specification.new do |s|
  s.name        = "travicator"
  s.version     = Travicator::VERSION
  s.author      = "Afterburner"
  s.email       = "support@afterburner.me"
  s.homepage    = "http://github.com/afterburner/travicator"
  s.summary     = "Command-line tool and webhooks server for travicator."
  s.description = "Install and manage a Travis CI--Phabricator bridge."
  s.executables = "travicator"
  s.license     = "MIT"

  s.files = %x{ git ls-files }.split("\n").select { |d| d =~ %r{^(LICENSE|lib/|bin/|arc/|git-hooks/)} }

  s.add_dependency "travis-yaml"
end
