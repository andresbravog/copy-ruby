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

and set up your api_key

    Copy.api_key = "_your_application_api_key_"


Oauth
=====

*[Copy oauth2 API documentation](https://signnow.atlassian.net/wiki/display/SAPI/REST+Endpoints#RESTEndpoints-POST/oauth2)*

Creating a oauth token:

    client = Signnow::Client.authenticate(
      email: 'yournewuser@email.com', # required
      password: 'user_password', # required
    )

    # Now you can perform any user api call inside the clien wrapper
    client.perform! do |token|
      Signnow::User.show(access_token: token)
    end


Users
=====

*[SignNow users API documentation](https://signnow.atlassian.net/wiki/display/SAPI/REST+Endpoints#RESTEndpoints-/user)*

Creating a user:

    user = Singnow::User.create(
      email: 'yournewuser@email.com', # required
      password: 'new_password', # required
      first_name: 'john', # optional
      last_name: 'doe', # optional
    )

Store the acess_token

    token = user.access_token

Generate a client with the access token

    client = Signnow::Client.new(token)

Showing a user:

    client.perform! |token|
      Singnow::User.show(access_token: token)
    end


Documents
=====

*[SignNow documents API documentation](https://signnow.atlassian.net/wiki/display/SAPI/REST+Endpoints#RESTEndpoints-/document)*

List user documents:

    client.perform! |token|
      Singnow::Document.all(access_token: token)
    end

Show a docuemnt:

    client.perform! |token|
      Singnow::Document.show(id: 'document_id', access_token: token)
    end

Download a docuemnt:

    client.perform! |token|
      Singnow::Document.download(id: 'document_id', access_token: token)
    end


Documentation
=====

*[SignNow developers page](https://developers.signnow.com)*

*[SignNow API documentation](https://signnow.atlassian.net/wiki/display/SAPI/REST+Endpoints)*


Requirements
=====

This gem requires at least Ruby 1.9 and faces version 1 of SignNow's API.

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
