require "travicator/verifier"
require "travicator/verifier/arc/properconfig"

require "tmpdir"
require "json"

module Travicator::Verifier::Arc
  describe ProperConfig do
    it "detects a properly setup .arcconfig" do
      uri = "http://trythis"
      Dir.mktmpdir { |tmp|
        Dir.chdir(tmp) do
          IO.write('.arcconfig', {
            "phabricator.uri" => uri,
            "arcanist_configuration" => "TravicatorArcanistConfiguration"
          }.to_json)
        end
        v = ProperConfig.new({ :directory => tmp, :config => { "phabricator.uri" => uri } } )
        v.run()
        expect(v.state).to be(Travicator::Verifier::SUCCESS)
        expect(v.error).to be_nil
      }
    end
    it "rejects a nonexistent .traviactor.yml" do
      uri = "http://trythis"
      Dir.mktmpdir { |tmp|
        Dir.chdir(tmp) do
          IO.write('.arcconfig', {
            "phabricator.uri" => uri,
            "arcanist_configuration" => "TravicatorArcanistConfiguration"
          }.to_json)
        end
        v = ProperConfig.new({ :directory => tmp, :config => nil } )
        v.run()
        expect(v.state).to be(Travicator::Verifier::FAILURE)
        expect(v.error).to be_a(String)
      }
    end
    it "detects an improper phabricator.uri" do
      uri = "http://trythis"
      Dir.mktmpdir { |tmp|
        Dir.chdir(tmp) do
          IO.write('.arcconfig', {
            "phabricator.uri" => "http://trythat",
            "arcanist_configuration" => "TravicatorArcanistConfiguration"
          }.to_json)
        end
        v = ProperConfig.new({ :directory => tmp, :config => { "phabricator.uri" => uri } } )
        v.run()
        expect(v.state).to be(Travicator::Verifier::FAILURE)
        expect(v.error).to be_a(String)
      }
    end
    it "detects an improper arcanist_configuration" do
      uri = "http://trythis"
      Dir.mktmpdir { |tmp|
        Dir.chdir(tmp) do
          IO.write('.arcconfig', {
            "phabricator.uri" => uri,
            "arcanist_configuration" => "something wrong"
          }.to_json)
        end
        v = ProperConfig.new({ :directory => tmp, :config => { "phabricator.uri" => uri } } )
        v.run()
        expect(v.state).to be(Travicator::Verifier::FAILURE)
        expect(v.error).to be_a(String)
      }
    end
    it "cannot be run twice" do
      uri = "http://trythis"
      Dir.mktmpdir { |tmp|
        v = ProperConfig.new({ :directory => tmp, :config => { "phabricator.uri" => uri } } )
        v.run()
        expect { v.run() }.to raise_error
      }
    end
  end
end
