# This example sets environmental variables that mutates the child process.
after_fork do |n, args|
  # Set the WOLF var to the instance of the wolf.
  ENV['WOLF'] = "Wolf #{n}"

  # Space the arguments passed into wolfpack with spaces.
  ENV['ARGS'] = args.join(' ')
end