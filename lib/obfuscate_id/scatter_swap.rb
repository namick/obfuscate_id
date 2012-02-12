class ScatterSwap
  # ScatterSwap is an integer hash function designed to have:
  # - zero collisions ( http://en.wikipedia.org/wiki/Perfect_hash_function )
  # - achieve avalanche ( http://en.wikipedia.org/wiki/Avalanche_effect )
  # - reversable
  #
  # Designing a hash function is a bit of a black art and
  # being that I don't have math background, I must resort
  # to this simplistic swaping and scattering of array elements.
  #
  # I welcome all improvments :-)
  #
  # We are working with a limited sequential set of input integers.
  # The largest value that a Mysql INT type is 2147483647
  # which is the same as 2 to the power of 31 minus 1
  #
  # That gives us more than 2 Billion records.. if you need more than
  # that, you might look for a different solution.
  #
  # We will start by zero padding the integer and turning it into an array.
  #
  # The key to creating a reversable hash must be that somehow the information is preserved
  # in the new number and the reverse hash can use that to reproduce the original number.
  #
  # One such piece of information could be the sum of digits
  #
  # This library basically works for integers that can be expressed with 10 digits:
  # It zero pads smaller numbers... so the number one is expressed with:
  # 0000000001
  # The biggest number it can deal with is:
  # 9999999999
  #
  # Every number within the above range is mapped to another number in that range.
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

  # obfuscates an integer up to 10 digits in length
  def self.hash(plain_integer, spin = 0)
    new(plain_integer, spin).hash
  end

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

  def hash
    swap
    scatter
    completed_string
  end

  def reverse_hash
    unscatter
    unswap
    completed_string
  end

  def completed_string
    @working_array.join
  end

  def completed_integer
    completed_string.to_i
  end

  # We want a unique map for each place in the original number
  def swapper_map(index)
    array = (0..9).to_a
    10.times.collect.with_index do |i|
      array.rotate!(index + i ^ spin).pop
    end
  end

  def swap
    @working_array = @working_array.collect.with_index do |digit, index|
      swapper_map(index)[digit]
    end
  end


  def unswap
    @working_array = @working_array.collect.with_index do |digit, index|
      swapper_map(index).rindex(digit)
    end
  end

  # rearrange the order of each digit in a reversable way by using the 
  # sum of the digits (which doesn't change regardless of order)
  # as a key to record how they were scattered
  def scatter
    sum_of_digits = @working_array.inject(:+).to_i
    @working_array = 10.times.collect do 
      @working_array.rotate!(spin ^ sum_of_digits).pop
    end
  end

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


  def spin
    @spin || 0
  end


end
