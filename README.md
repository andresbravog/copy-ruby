# [WIP] work in progress!!!

Copy [![Build Status](https://secure.travis-ci.org/andresbravog/copy-ruby.png)](https://travis-ci.org/andresbravog/copy-ruby) [![Code Climate](https://codeclimate.com/github/andresbravog/copy-ruby.png)](https://codeclimate.com/github/andresbravog/copy-ruby) [![Coverage Status](https://coveralls.io/repos/andresbravog/copy-ruby/badge.png)](https://coveralls.io/r/andresbravog/copy-ruby)
======

This is a Ruby wrapper for copy's API.

Documentation
=====

We use RubyDoc for documentation.

Usage
======

First, you've to install the gem

    gem install copy

and require it

    require "copy"

and set up your app credentials

    Copy.config do |configuration|
      configuration[:consumer_key] = '_your_consumer_key_'
      configuration[:consumer_secret] = '_your_consumer_secret_'
    end

in fact this last step is optional (yes! we support multiple applications) but if as all humans you use only one copy app is easy to do it like this.


Oauth
=====

*[Copy oauth2 API documentation](https://www.copy.com/developer/documentation#authentication)*

using omniauth? :+1: good choice, just try this gem

  *[plexinc/omniauth-copy](https://github.com/plexinc/omniauth-copy)*

not using omniauth,? no prob oauth implementation comming soon

  ...


Client
======

Everything starts with the client, once you have the user credentials you should create a session and a client to start interaction with the API

    session = Copy::Session.new(
      token: '_your_user_token_',
      secret: '_your_user_secret_'
    )
    client = Copy::Client.new(session)

Now you can perform any user api call inside the clien wrapper

    client.user(:show)

If you have multiple applications or you just want to ve explicit use the application credentials inside the session creation

    session = Copy::Session.new(
      token: '_your_user_token_',
      secret: '_your_user_secret_',
      consumer_key: '_your_app_key_',
      consumer_secret: '_your_app_secret'
    )
    client = Copy::Client.new(session)

Users
=====

*[Copy users API documentation](https://www.copy.com/developer/documentation#api-calls/profile)*

Showing user profile:

    user = client.user(:show)

Updating user (only last_name or first_name)

    user = client.user(:update, { first_name: 'New name', last_name: 'New last name'})

Files
=====

*[Copy files API documentation](https://www.copy.com/developer/documentation#api-calls/filesystem)*

Showing root dir:

    file = client.file(:show)

listing dir children:

files has children if is a dir and is not sutbbed (already being listed form his father)

    if file.is_dir?
      file = client.file(:show, id: file.id ) if file.stubbed?
      file.children
    end


Documentation
=====

*[Copy developers page](https://www.copy.com/developer/signup/)*

*[Copy API documentation](https://www.copy.com/developer/documentation)*


Requirements
=====

This gem requires at least Ruby 1.9 and faces version 1 of Copy's API.

Bugs
======

Please report bugs at http://github.com/andresbravog/copy-ruby/issues.

Note on Patches/Pull Requests
======

* Fork the project from http://github.com/andresbravog/copy-ruby.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

Copyright
======

Copyright (c) 2012-2013 andresbravog Internet Service GmbH, Andres Bravo. See LICENSE for details.
