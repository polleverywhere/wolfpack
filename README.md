    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@'~~~     ~~~`@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @@@@@@@@@@@@@@@@@@@@@@@@'                     `@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @@@@@@@@@@@@@@@@@@@@@'                           `@@@@@@@@@@@@@@@@@@@@@@@@@
    @@@@@@@@@@@@@@@@@@@'                               `@@@@@@@@@@@@@@@@@@@@@@@
    @@@@@@@@@@@@@@@@@'            Wolfpack               `@@@@@@@@@@@@@@@@@@@@@
    @@@@@@@@@@@@@@@@'                                     `@@@@@@@@@@@@@@@@@@@@
    @@@@@@@@@@@@@@@'     A really stupid way to run        `@@@@@@@@@@@@@@@@@@@
    @@@@@@@@@@@@@@@      a bunch of tasks in parallel.      @@@@@@@@@@@@@@@@@@@
    @@@@@@@@@@@@@@'                                         `@@@@@@@@@@@@@@@@@@
    @@@@@@@@@@@@@@                                           @@@@@@@@@@@@@@@@@@
    @@@@@@@@@@@@@@                                           @@@@@@@@@@@@@@@@@@
    @@@@@@@@@@@@@@                       n,  Awhoooooooo!    @@@@@@@@@@@@@@@@@@
    @@@@@@@@@@@@@@                     _/ | _                @@@@@@@@@@@@@@@@@@
    @@@@@@@@@@@@@@                    /'  `'/                @@@@@@@@@@@@@@@@@@
    @@@@@@@@@@@@@@a                 <~    .'                a@@@@@@@@@@@@@@@@@@
    @@@@@@@@@@@@@@@                 .'    |                 @@@@@@@@@@@@@@@@@@@
    @@@@@@@@@@@@@@@a              _/      |                a@@@@@@@@@@@@@@@@@@@
    @@@@@@@@@@@@@@@@a           _/      `.`.              a@@@@@@@@@@@@@@@@@@@@
    @@@@@@@@@@@@@@@@@a     ____/ '   \__ | |______       a@@@@@@@@@@@@@@@@@@@@@
    @@@@@@@@@@@@@@@@@@@a__/___/      /__\ \ \     \___.a@@@@@@@@@@@@@@@@@@@@@@@
    @@@@@@@@@@@@@@@@@@@/  (___.'\_______)\_|_|        \@@@@@@@@@@@@@@@@@@@@@@@@
    @@@@@@@@@@@@@@@@@@|\________                       ~~~~~\@@@@@@@@@@@@@@@@@@
    ~~~\@@@@@@@@@@@@@@||       |\___________________________/|@/~~~~~~~~~~~\@@@
        |~~~~\@@@@@@@/ |  |    | | by: S.C.E.S.W.          | ||\____________|@@

## Why Wolfpack?

One day you realize your CI server takes over an hour to run 2000 specs. Since you're an awesome developer and have fully embraced [The Twelve Factor App](http://12factor.net/) all you want to do is break this massive rspec runner into a bunch of sub-processes that can get the job done in parallel. Wouldn't be awesome if there was a little tool that would let you setup multiple environments of your app on the same machine and run tests against them? You're in luck, because that's what Wolfpack is all about!

## Usage

Wolfpack can be used for more than just a Rails app, but making specs run faster is such a great example to demonstrate how the whole thing works, so create a config file in your rails app.

```ruby
# config/wolfpack.rb
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
  ENV['SPEC_FILES'] = args.join(' ')

  # And whatever else you need to deal with...
end
```

Then run wolfpack with the config file.

```sh
# Running the wolfpack command on a 4 processor machine. Your machine might 
# run with a different number of workers depending on processors.
$ wolfpack run 'echo "Using $DATABASE_URL"; rake db:create db:schema:load; rspec $SPEC_FILES;' \
    -c config/wolfpack.rb
    --args `find spec/**/**_spec.rb`
Using mysql2://localhost/app_test_0
Using mysql2://localhost/app_test_1
Using mysql2://localhost/app_test_2
Using mysql2://localhost/app_test_3
# All of the spec output will be displayed here..
```

Pretty cool huh? As you can imagine, Wolfpack can be used to parallelize the execution of any unix program.

## Installation

Add this line to your application's Gemfile:

    gem 'wolfpack'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install wolfpack

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
