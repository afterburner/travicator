require "travicator/verifier"
require "travicator/verifier/arc/arcconfig"

require "tmpdir"
require "json"

module Travicator::Verifier::Arc
  describe ArcConfig do
    it "detects a valid .arcconfig" do
      Dir.mktmpdir { |tmp|
        Dir.chdir(tmp) do
          IO.write('.arcconfig', [].to_json)
        end
        v = ArcConfig.new({ :directory => tmp })
        v.run()
        expect(v.state).to be(Travicator::Verifier::SUCCESS)
        expect(v.error).to be_nil
      }
    end
    it "detects no .arcconfig" do
      Dir.mktmpdir { |tmp|
        v = ArcConfig.new({ :directory => tmp })
        v.run()
        expect(v.state).to be(Travicator::Verifier::FAILURE)
        expect(v.error).to be_a(String)
      }
    end
    it "detects an invalid .arcconfig" do
      Dir.mktmpdir { |tmp|
        Dir.chdir(tmp) do
          IO.write('.arcconfig', '[{]');
        end
        v = ArcConfig.new({ :directory => tmp })
        v.run()
        expect(v.state).to be(Travicator::Verifier::FAILURE)
        expect(v.error).to be_a(String)
      }
    end
    it "cannot be run twice" do
      Dir.mktmpdir { |tmp|
        v = ArcConfig.new({ :directory => tmp })
        v.run()
        expect { v.run() }.to raise_error
      }
    end
  end
end
