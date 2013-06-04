require "wolfpack/version"
require "facter"
require "thor"

module Wolfpack
  # Count the number of processors on the machine.
  def self.processors
    Facter.processorcount
  end

  # Configure a runner instance
  class Configurator
    def initialize(runner, config_path)
      @runner = runner
      instance_eval(File.read(config_path), config_path)
    end

    # Replace the instances after_fork hook with after_fork 
    # from the configuration file.
    #
    # @example
    # after_fork do |n|
    #   ENV['DATABASE_URL'] = "#{ENV['DATABASE_URL']}_#{n}"
    # end
    def after_fork(&block)
      @runner.class.send :define_method, :after_fork, &block
    end
  end

  # Encapsulates a command that is te be split up and run.
  class Runner
    def initialize(command, config_path = nil)
      @command = command
      configure(config_path) if config_path
    end

    # Run the command `n` number of times. Default is the number of processes
    # on the local machine.
    def run(times=Wolfpack.processors)
      times.to_i.times do |n|
        pid = fork do
          after_fork n
          system @command
        end
      end
    end

    # Configures the runner's by reading a configuration file and eval-ing
    # the ruby.
    def configure(config_path)
      Configurator.new(self, config_path)
    end

    # Stub for callback that the runner calls between requests.
    def after_fork(n)
    end
  end

  class CLI < Thor
    desc "exec COMMAND", "Runs many tasks in parallel"
    method_options %w( config -c ) => :string
    def exec(command)
      Wolfpack::Runner.new(command, options[:config]).run
    end

    desc "version", "Wolfpack version"
    def version
      puts Wolfpack::VERSION
    end

    desc "processors", "Count of processors on machine"
    def processors
      puts Wolfpack.processors
    end
  end
end
