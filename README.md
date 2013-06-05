# Wolfpack

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


## Installation

Add this line to your application's Gemfile:

    gem 'wolfpack'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install wolfpack

## Usage

Create a config file.

    # config/wolfpack.rb
    before_exec do |n|
      ENV['DATABASE_URL'] = "test_db_#{n}"
    end

Then run wolfpack with the config file.

    # Runnin the wolfpack command on a 4 processor machine.
    $ wolfpack run 'echo $DATABASE_URL' -c config/wolfpack.rb
    test_db_0
    test_db_1
    test_db_2
    test_db_3

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
