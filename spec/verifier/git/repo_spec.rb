require "travicator/verifier"
require "travicator/verifier/git/repo"

require "tmpdir"

module Travicator::Verifier::Git
  describe Repo do
    it "detects a valid git repo" do
      Dir.mktmpdir { |tmp|
        Dir.chdir(tmp) do
          `git init .`
        end
        v = Repo.new({ :directory => tmp })
        v.run()
        expect(v.state).to be(Travicator::Verifier::SUCCESS)
        expect(v.error).to be_nil
      }
    end
    it "detects no git repo" do
      Dir.mktmpdir { |tmp|
        v = Repo.new({ :directory => tmp })
        v.run()
        expect(v.state).to be(Travicator::Verifier::FAILURE)
        expect(v.error).to be_a(String)
      }
    end
    it "cannot be run twice" do
      Dir.mktmpdir { |tmp|
        v = Repo.new({ :directory => tmp })
        v.run()
        expect { v.run() }.to raise_error
      }
    end
  end
end
