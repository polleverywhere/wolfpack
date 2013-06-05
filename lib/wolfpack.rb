require "wolfpack/version"
require "thor"
require "parallel"

module Wolfpack
  # Gets the number of "processors" on the current machine. This does not map
  # directly to physical cores. For example, a hyperthreaded Intel chip may 
  # have 2 physical cores but show up as 4 cores.
  def self.processor_count
    @processor_count ||= Parallel.processor_count
  end

  # Configure a runner instance
  class Configurator
    attr_reader :runner

    # Configures the instance of a given runner with a file.
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
      runner.after_fork = block
    end
  end

  # Encapsulates a command that is te be split up and run.
  class Runner
    attr_accessor :after_fork, :command, :args

    # Create a command that will run with the give arguments. Optionally
    # a path may be given to a configuration file that sets up a runner.
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

      # Split args into groups of n processes.
      partions = partition(args, processes)

      # Now run the command with the processes.
      Parallel.each_with_index(partions, :in_processes => processes) do |args, n|
        after_fork.call(n, args) if after_fork
        system @command
      end
    end

    # Configures the runner's by reading a configuration file and eval-ing
    # the ruby.
    def configure(config_path)
      Configurator.new(self, config_path)
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
    method_options %w( args -a ) => :array
    def exec(command)
      # Parse out an integer for the # of processors the user specifies since
      # thor doesn't return an integer for its params.
      processes = options[:processes].to_i if options[:processes]

      # Process stdin that's piped in.
      args = if $stdin.tty?
        options[:args] || []
      else
        # Read from the pipe
        buffer = ""
        until $stdin.eof? do
          buffer << $stdin.read
        end
        buffer.lines
      end

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
