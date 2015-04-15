# obfuscate_id
[![Build Status](https://secure.travis-ci.org/namick/obfuscate_id.png)](http://travis-ci.org/namick/obfuscate_id) [![Dependency Status](https://gemnasium.com/namick/obfuscate_id.png)](https://gemnasium.com/namick/obfuscate_id) [![Code Climate](https://codeclimate.com/github/namick/obfuscate_id.png)](https://codeclimate.com/github/namick/obfuscate_id)

**Make your ActiveRecord ids non-obvious**

![cat with sunglasses](http://i.imgur.com/kYOtUll.jpg)


obfuscate_id turns a URL like this:

    http://example.com/users/3

into something like:

    http://example.com/users/2356513904

Sequential ActiveRecord ids become non-sequential, random looking, numeric ids.

    # post 7000
    http://example.com/posts/5270192353
    # post 7001
    http://example.com/posts/7107163820
    # post 7002
    http://example.com/posts/3296163828

## Why would you want this?

If your site is scaling well, you might not want to leak that you are getting 50 new posts a minute.

Or, for new websites, you may not want to give away how few people are signed up.

Every website has a third user, but that third user doesn't have to know he is the third user.

## Features

* Extremely simple. A single line of code in the model turns it on.
* Transforms normal seqential ids into random-looking ten digit numerical strings.
* Gently masks resource ids while retaining a cleaner look than using an encrypted hash.
* No database changes or migrations are needed.  The record is still stored in the database with its original id.
* Fast, no heavy calculation.


## Installation

Add the gem to your Gemfile.

    gem "obfuscate_id"

Run bundler.

    bundle install

## Usage

In your model, add a single line.

    class Post < ActiveRecord::Base
      obfuscate_id
    end

## Customization

If you want your obfuscated ids to be different than some other website using the same plugin, you can throw a random number (spin) at obfuscate_id to make it hash out unique ids for your app.

    class Post < ActiveRecord::Base
      obfuscate_id :spin => 89238723
    end

## How it works

obfuscate_id mixes up the ids in a simple, reversable hashing algorithm so that it can then automatically revert the hashed number back to the original id for record lookup without having to store a hash or tag in the database.

Each number from 0 to 9,999,999,999 is paired with one and only one number in that same range.  That other number is paired back to the first.  This is an example of a minimal perfect hash function.   Within a set of ten billion numbers, it simply maps every number to a different 10 digit number, and back again.

Plain record ids are switched to the obfuscated id in the model's `to_param` method.

ActiveRecord reverses this obfuscated id back to the plain id before building the database query. This means no migrations or changes to the database.  Yay!

## Limitations

* This is not security.  obfuscate_id was created to lightly mask record id numbers for the casual user.  If you need to really secure your database ids (hint, you probably don't), you need to use real encryption like AES.
* To properly generate obfuscated urls, make sure you trigger the model's `to_param` method by passing in the whole object rather than just the id; do this: `post_path(@post)` not this: `post_path(@post.id)`.

## Versions

This is tested with Rails 4.2.0.  For other versions of Rails, please see [the releases](https://github.com/namick/obfuscate_id/releases).

If you are trying to get it to work with a different version of rails that is not tested, let me know in [the issues](https://github.com/namick/obfuscate_id/issues)

## Development

To run the tests, first clone the repo and run bundler:

    git clone git@github.com:namick/obfuscate_id.git
    cd obfuscate_id
    bundle install

Run the tests

    bundle exec rspec spec

Or have Guard run them continuously

    bundle exec guard

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
