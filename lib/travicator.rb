require "yaml"

module Travicator
  def self.assets_dir
    File.dirname(__FILE__) + '/../assets'
  end

  def self.config
    if defined? @@config
      return @@config
    end

    # Search paths for a .travicator.yml
    dir = Dir.pwd
    prevdir = dir
    begin 
      begin
        @@config = YAML::load_file(File.join(dir, '/.travicator.yml'))

        # Does it contain a valid configuration?
        if defined? @@config["phabricator.uri"] &&
           defined? @@config["webhook"]
          return @@config
        end
      rescue
        # carry on...
      end
      prevdir = dir
      dir = File.expand_path("..", dir)
    end while prevdir != dir

    raise "Can't find a valid .travicator.yml file"
  end
end
