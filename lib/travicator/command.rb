module Travicator
  module Command
    def self.run(command, args)
      klass = commands[command]
      if !klass
        klass = commands[:help]
      end
      if !klass
        puts "Can't find any commands to run!"
        exit 1
      end
      klass.new.run()
    end

    def self.commands
      @@commands ||= {}
    end

    def self.load
      # Load all the commands, triggering them to  be registered in the
      # commands dictionary.
      Dir[File.dirname(__FILE__) + '/command/*.rb'].each { |file| require file }
    end

    def self.register(klass)
      # Command names are class names, downcased.
      commands[klass.to_s.split("::").last.downcase] = klass
    end
  end
end
