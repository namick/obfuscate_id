# ObfuscateId

ObfuscateId is a simple plugin that hides your sequential numerical ids in a shroud of secrecy.

Every website has a third user, but that third user doesn't have to know he is the third user.

ObfuscateId turns a URL like this:

    http://example.com/users/3

into something like:

    http://example.com/users/235651390

and then automatically reverts the id back to 3 for record lookup without having to store a hash or tag in the database.

Or maybe you have the opposite problem, your site is scaling well, you are getting 50 new posts a minute, but do you want to leak that information?

ObfuscateId turns your sequential Active Record ids into non-sequential, random looking, numeric ids.

    # post 7000
    http://example.com/posts/527019235
    # post 7001
    http://example.com/posts/710716382
    # post 7002
    http://example.com/posts/329616382

## Features

* Extreemly simple. A single line of code in the model turns it on.
* No database changes are needed.  The record is still stored in the database with its original id.
* Creates a random looking integer which hides the id but still looks cleaner than a using an encrypted hash
* Fast, no heavy calculation
* Supported by all common Rails databases.


## Installation

Add the gem to your Gemfile.

    gem "obfuscate_id"

Run bundler

    bundle install

Generate the initilizer file

    rails generate obfuscate_id:install

Then, in your model, add a single line.  

    class Post < ActiveRecord::Base
      obfuscate_id
    end


