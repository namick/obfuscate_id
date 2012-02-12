# ObfuscateId

ObfuscateId is a simple Ruby on Rails plugin that hides your seqential Active Record ids.  Although having nothing to do with security, it can be used to make database record id information non-obvious.

For new websites, you may not want to give away information about how many people are signed up.  Every website has a third user, but that third user doesn't have to know he is the third user.

ObfuscateId turns a URL like this:

    http://example.com/users/3

into something like:

    http://example.com/users/2356513904
    
ObfuscateId mixes up the ids in a simple, reversable hashing algorithm so that it can then automatically revert the hashed number back to 3 for record lookup without having to store a hash or tag in the database.  No migrations needed.

If you have the opposite problem, and your site is scaling well, you might not want to leak that you are getting 50 new posts a minute.

ObfuscateId turns your sequential Active Record ids into non-sequential, random looking, numeric ids.

    # post 7000
    http://example.com/posts/5270192353
    # post 7001
    http://example.com/posts/7107163820
    # post 7002
    http://example.com/posts/3296163828

## Features

* Extreemly simple. A single line of code in the model turns it on.
* No migrations or database changes are needed.  The record is still stored in the database with its original id.
* Creates a random looking integer which hides the id but still looks cleaner than a using an encrypted hash.
* Fast, no heavy calculation.


## Installation

Add the gem to your Gemfile.

    gem "obfuscate_id"

Run bundler

    bundle install

Then, in your model, add a single line.  

    class Post < ActiveRecord::Base
      obfuscate_id
    end

## Customization

If you want your obfuscated ids to be different than some other website using the same plugin, you can throw a random number (spin) at obfuscate_id to make it hash out unique ids.

    class Post < ActiveRecord::Base
      obfuscate_id :spin => 89238723
    end

