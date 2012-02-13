# ObfuscateId [![Build Status](https://secure.travis-ci.org/namick/obfuscate_id.png)](http://travis-ci.org/namick/obfuscate_id) [![Dependency Status](https://gemnasium.com/namick/obfuscate_id.png)](https://gemnasium.com/namick/obfuscate_id)

ObfuscateId is a simple Ruby on Rails plugin that hides your seqential Active Record ids.  Although having nothing to do with security, it can be used to make database record id information non-obvious.

For new websites, you may not want to give away information about how many people are signed up.  Every website has a third user, but that third user doesn't have to know he is the third user.

ObfuscateId turns a URL like this:

    http://example.com/users/3

into something like:

    http://example.com/users/2356513904
    
ObfuscateId mixes up the ids in a simple, reversable hashing algorithm so that it can then automatically revert the hashed number back to the original id for record lookup without having to store a hash or tag in the database.  No migrations needed.

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
* Transforms normal seqential ids into random-looking ten digit numerical strings.
* Gently masks resource ids while retaining a cleaner look than using an encrypted hash.
* No migrations or database changes are needed.  The record is still stored in the database with its original id.
* Fast, no heavy calculation.


## Installation

Add the gem to your Gemfile.

    gem "obfuscate_id"

Run bundler.

    bundle install

Then, in your model, add a single line.  

    class Post < ActiveRecord::Base
      obfuscate_id
    end

## Customization

If you want your obfuscated ids to be different than some other website using the same plugin, you can throw a random number (spin) at obfuscate_id to make it hash out unique ids for your app.

    class Post < ActiveRecord::Base
      obfuscate_id :spin => 89238723
    end

This is also useful for making different models in the same app have different obfuscated ids.

## How it works

ObfuscateId pairs each number, from 0 to 9999999999, with one and only one number in that same range.  That other number is paired back to the first.  This is an example of a minimal perfect hash function.   Within a set of ten billion numbers, it simply maps every number to a different 10 digit number, and back again.

ObfuscateId switches the plain record id to the obfuscated id in the models `to_param` method.

It then augments Active Record's `find` method on models that have have been initiated with the `obfuscate_id` method to quickly reverse this obfuscated id back to the plain id before building the database query. This means no migrations or changes to the database.

## Limitations

* This is not security.  ObfuscateId was created to lightly mask record id numbers for the casual user.  If you need to really secure your database ids (hint, you probably don't), you need to use real encryption like AES.
* Works for up to ten billion database records.  ObfuscateId simply maps every integer below ten billion to some other number below ten billion.
* To properly generate obfuscated urls, make sure you trigger the model's `to_param` method by passing in the whole object rather than just the id; do this: `post_path(@post)` not this: `post_path(@post.id)`.
* Rails uses the real id rather than `to_param` in some places.  A simple view-source on a form will often show the real id. This can be avoided by taking certain precautions. 

