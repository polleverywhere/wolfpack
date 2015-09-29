# So, you're a http://12factor.net/ hotshot? You're in luck because
# it will be pretty easy to get wolfpack working with your specs.

after_fork do |n, args|
  # This will create n different database variables. Rails `rake db:create db:schema:load`
  # should pick this up for test setup.
  ENV['DATABASE_URL'] = "mysql2://localhost/app_test_#{n}"

  # Using redis? Cool! But lets partition that too. The bummer here is that
  # redis limits us to 16 databases, so we should throw an exception just
  # to make that clear.
  raise 'Redis only supports 0-15 databases' unless n < 16
  ENV['REDIS_URL'] = "redis://localhost/#{n}"

  # We'll feed in a list of specs that we want to run from stdin,
  # concat with a space, and output into an ENV var that rspec will pick up.
  ENV['SPEC_FILES'] = args.map(&:chomp).join(" ")

  # And whatever else you need to deal with...
end

__END__

Now you're ready to run this! Try something like this on your CLI:

$ bundle exec wolfpack exec "rake db:setup db:schema:load; rspec $SPEC_FILES;"

and you're off to the races! In practice its probably not that easy though because
specs are generally not developed initially with concurrency in mind.
