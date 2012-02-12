class ScatterSwap
  # This is the hashing function behind ObfuscateId.
  # https://github.com/namick/obfuscate_id
  #
  # Designing a hash function is a bit of a black art and
  # being that I don't have math background, I must resort
  # to this simplistic swaping and scattering of array elements.
  #
  # After writing this and reading/learning some elemental hashing techniques,
  # I realize this library is what is known as a Minimal perfect hash function:
  # http://en.wikipedia.org/wiki/Perfect_hash_function#Minimal_perfect_hash_function
  #
  # I welcome all improvements :-)
  #
  # If you have some comments or suggestions, please contact me on github
  # https://github.com/namick
  #
  # - nathan amick
  # 
  #
  # This library is built for integers that can be expressed with 10 digits:
  # It zero pads smaller numbers... so the number one is expressed with:
  # 0000000001
  # The biggest number it can deal with is:
  # 9999999999
  #
  # Since we are working with a limited sequential set of input integers, 10 billion,
  # this algorithm will suffice for simple id obfuscation for many web apps.
  # The largest value that Ruby on Rails default id, Mysql INT type, is just over 2 billion (2147483647)
  # which is the same as 2 to the power of 31 minus 1, but considerably less than 10 billion.
  #
  # ScatterSwap is an integer hash function designed to have:
  # - zero collisions ( http://en.wikipedia.org/wiki/Perfect_hash_function )
  # - achieve avalanche ( http://en.wikipedia.org/wiki/Avalanche_effect )
  # - reversable
  #
  # We do that by combining two distinct strategies.
  #
  # 1. Scattering - whereby we take the whole number, slice it up into 10 digits
  # and rearange their places, yet retaining the same 10 digits.  This allows
  # us to preserve the sum of all the digits, regardless of order.  This sum acts
  # as a key to reverse this scattering effect.
  # 
  # 2. Swapping - when dealing with many sequential numbers that we don't want
  # to look similar, scattering wont do us much good because so many of the
  # digits are the same; it deoesn't help to scatter 9 zeros around, so we need
  # to swap out each of those zeros for something else.. something different
  # for each place in the 10 digit array; for this, we need a map so that we
  # can reverse it.

  # Convience class method pointing to the instance method
  def self.hash(plain_integer, spin = 0)
    new(plain_integer, spin).hash
  end

  # Convience class method pointing to the instance method
  def self.reverse_hash(hashed_integer, spin = 0)
    new(hashed_integer, spin).reverse_hash
  end

  def initialize(original_integer, spin = 0)
    @original_integer = original_integer
    @spin = spin
    zero_pad  = original_integer.to_s.rjust(10, '0')
    @working_array = zero_pad.split("").collect {|d| d.to_i}
  end

  attr_accessor :working_array

  # obfuscates an integer up to 10 digits in length
  def hash
    swap
    scatter
    completed_string
  end

  # de-obfuscates an integer
  def reverse_hash
    unscatter
    unswap
    completed_string
  end

  def completed_string
    @working_array.join
  end

  # We want a unique map for each place in the original number
  def swapper_map(index)
    array = (0..9).to_a
    10.times.collect.with_index do |i|
      array.rotate!(index + i ^ spin).pop
    end
  end

  # Using a unique map for each of the ten places,
  # we swap out one number for another
  def swap
    @working_array = @working_array.collect.with_index do |digit, index|
      swapper_map(index)[digit]
    end
  end

  # Reverse swap
  def unswap
    @working_array = @working_array.collect.with_index do |digit, index|
      swapper_map(index).rindex(digit)
    end
  end

  # Rearrange the order of each digit in a reversable way by using the 
  # sum of the digits (which doesn't change regardless of order)
  # as a key to record how they were scattered
  def scatter
    sum_of_digits = @working_array.inject(:+).to_i
    @working_array = 10.times.collect do 
      @working_array.rotate!(spin ^ sum_of_digits).pop
    end
  end

  # Reverse the scatter
  def unscatter
    scattered_array = @working_array
    sum_of_digits = scattered_array.inject(:+).to_i
    @working_array = []
    @working_array.tap do |unscatter| 
      10.times do
        unscatter.push scattered_array.pop
        unscatter.rotate! (sum_of_digits ^ spin) * -1
      end
    end
  end

  # Add some spice so that different apps can have differently mapped hashes
  def spin
    @spin || 0
  end
end
