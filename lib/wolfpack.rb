require "wolfpack/version"
require "thor"
require "parallel"
require "erb"

module Wolfpack
  def self.processor_count
    @processor_count ||= Parallel.processor_count
  end

  # Configure a runner instance
  class Configurator
    # Configures the instance of a given runner.
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
    def initialize(command, args = [], config_path = nil)
      @command, @args = command, args
      configure(config_path) if config_path
    end

    # Run the command `n` number of times. Default is the number of processes
    # on the local machine.
    def run(processes = nil)
      # Sometimes a nil will make it here because of the CLI. This will
      # make sure we have a number to work with.
      processes ||= Wolfpack.processor_count

      # Split args into groups of n processes
      args = partition @args, processes

      # Now run the command with the processes.
      Parallel.each_with_index(args, :in_processes => processes) do |args, n|
        after_fork n
        system ERB.new(@command).result(Struct.new(:args).new(:args => args).send(:binding))
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

  private
    # Take an array and break it into `n` partitions
    def partition(arr, n)
      result = Array.new(n){ [] }
      arr.each_with_index do |el, idx|
        result[idx % n].push el
      end
      result
    end
  end

  class CLI < Thor
    desc "exec COMMAND", "Runs many tasks in parallel"
    method_options %w( config -c ) => :string
    method_options %w( processes -n ) => :integer
    def exec(command)
      # Parse out an integer for the # of processors the user specifies since
      # thor doesn't return an integer for its params.
      processes = options[:processes].to_i if options[:processes]

      args = STDIN.read.split

      # If args are passed in, read those and split, otherwise read stdin 
      # from a pipe and split by lines.

      Wolfpack::Runner.new(command, args, options[:config]).run(processes)
    end

    desc "version", "Wolfpack version"
    def version
      puts Wolfpack::VERSION
    end

    desc "processors", "Count of processors on machine"
    def processors
      puts Wolfpack.processor_count
    end
  end
end
