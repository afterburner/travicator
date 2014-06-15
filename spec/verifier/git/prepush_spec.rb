require "travicator/verifier"
require "travicator/verifier/git/prepush"

require "tmpdir"

module Travicator::Verifier::Git
  describe PrePush do
    it "detects a correctly installed pre-push hook" do
      Dir.mktmpdir { |tmp|
        Dir.chdir(tmp) do
          `git init .`
          `cp "#{Travicator.assets_dir}/git-hooks/pre-push" "#{tmp}/.git/hooks"`
        end
        v = PrePush.new({ :directory => tmp })
        v.run()
        expect(v.state).to be(Travicator::Verifier::SUCCESS)
        expect(v.error).to be_nil
      }
    end
    it "detects no pre-push hook" do
      Dir.mktmpdir { |tmp|
        Dir.chdir(tmp) do
          `git init .`
        end
        v = PrePush.new({ :directory => tmp })
        v.run()
        expect(v.state).to be(Travicator::Verifier::FAILURE)
        expect(v.error).to be_a(String)
      }
    end
    it "detects invalid pre-push hook" do
      Dir.mktmpdir { |tmp|
        Dir.chdir(tmp) do
          `git init .`
          `touch "#{tmp}/.git/hooks/pre-push"`
        end
        v = PrePush.new({ :directory => tmp })
        v.run()
        expect(v.state).to be(Travicator::Verifier::FAILURE)
        expect(v.error).to be_a(String)
      }
    end
    it "cannot be run twice" do
      Dir.mktmpdir { |tmp|
        v = PrePush.new({ :directory => tmp })
        v.run()
        expect { v.run() }.to raise_error
      }
    end
  end
end
