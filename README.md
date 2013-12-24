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

```Ruby
  gem install copy
```

and require it

```Ruby
  require "copy"
```

and set up your app credentials


```Ruby
  Copy.config do |configuration|
    configuration[:consumer_key] = '_your_consumer_key_'
    configuration[:consumer_secret] = '_your_consumer_secret_'
  end
```

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

```Ruby
  session = Copy::Session.new(
    token: '_your_user_token_',
    secret: '_your_user_secret_'
  )
  client = Copy::Client.new(session)
```

Now you can perform any user api call inside the clien wrapper

```Ruby
  client.user(:show)
```

If you have multiple applications or you just want to ve explicit use the application credentials inside the session creation

```Ruby
  session = Copy::Session.new(
    token: '_your_user_token_',
    secret: '_your_user_secret_',
    consumer_key: '_your_app_key_',
    consumer_secret: '_your_app_secret'
  )
  client = Copy::Client.new(session)
```

Users
=====

*[Copy users API documentation](https://www.copy.com/developer/documentation#api-calls/profile)*

Showing user profile:

```Ruby
  user = client.user(:show)
```

Updating user (only last_name or first_name)

```Ruby
  user = client.user(:update, { first_name: 'New name', last_name: 'New last name'})
```

Files
=====

*[Copy files API documentation](https://www.copy.com/developer/documentation#api-calls/filesystem)*

Showing root dir:

```Ruby
 file = client.file(:show)
```

listing dir children:

files has children if is a dir and is not sutbbed (already being listed form his father)

```Ruby
  if file.is_dir?
    file = client.file(:show, id: file.id ) if file.stubbed?
    file.children
  end
```

get file revisions

```Ruby
  file = client.file(:activity, id: '/copy/readme.txt')
  revisions = file.revisions
  file_revision = client.file(:show, id: revisions.first.id )
```

delete a file

```Ruby
  client.file(:delete, id: '/test/readme.txt')
```

create a file. You need to provide a valid copy directory and a file (currently we accept File, Tempfile, String or StringIO objects )

```Ruby
  file = client.file(:create, path: '/test/readme.txt', file: File.open('path/to/file'))
```

Links
=====

*[Copy links API documentation](https://www.copy.com/developer/documentation#api-calls/links)*

List all links created by the user

```Ruby
  links = client.file(:all)
```

Show a link

```Ruby
  link = client.file(:show, id: links.first.id )
```

List link recipients. Returns a list of users

```Ruby
  link.recipients if !link.public
```

Create a new link

```Ruby
  link = client.link( :create,
    name: 'My new fancy link',
    public: true,
    paths: [
      '/path/to/the/file_1.txt',
      '/path/to/the/file_2.txt'
    ]
  )
```

Delete a existing link

```Ruby
  client.link( :delete, id: link.id )
```

Get metadata of a link

```Ruby
  link = client.link( :meta, id: link.id )
  files = link.children
```


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


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/andresbravog/copy-ruby/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

