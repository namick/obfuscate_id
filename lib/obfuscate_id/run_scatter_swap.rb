require './scatter_swap.rb'

# While developing this, I used this file to visualize what was going on with the numbers
#
# you can run it like this:
#
# watch -n1 ruby run_scatter_swap.rb

def visualize_scatter_and_unscatter
  # change this number to experiment with different values
  rotations = 99

  original = ScatterSwap.arrayify(123456789)
  scattered = []
  unscattered = []
  puts original.join
  puts "rotate!(#{rotations})"
  10.times do
    puts original.rotate!(rotations).join + "->" + scattered.push(original.pop).join
  end
  puts "scattered"
  puts scattered.join
  10.times do
    puts unscattered.push(scattered.pop).join + "->" + unscattered.rotate!(rotations * -1).join
  end

  puts unscattered.join
end


def visualize_swapper_map
  puts "swapper map"
  10.times do |index|
    key = 1
    puts ScatterSwap.swapper_map(index).join.to_s
  end
end

def visualize_hash
  puts "hash"
  40.times do |integer|
    output = "|"
    3.times do |index|
      output += " #{(integer + (123456789 * index)).to_s.rjust(5, ' ')}"
      output += " => #{hashed = ScatterSwap.hash(integer + (123456789 * index) ) }"
      output += " => #{ScatterSwap.reverse_hash(hashed) } |"
    end
    puts output
  end
end


def visualize_scatter
  puts "original      scattered     unscattered"
  20.times do |integer|
    output = ""
    2.times do |index|
      original = ScatterSwap.arrayify(integer + (123456789 * index))
      scattered = ScatterSwap.scatter(original.clone)
      unscattered = ScatterSwap.unscatter(scattered.clone)
      output += "#{original.join}" 
      output += " => #{scattered.join}"
      output += " => #{unscattered.join}    |    "
    end
    puts output
  end
end


# find hash for lots of spins
def visualize_spin
  2000.times do |original|
    hashed_values = []
    9000000000.times do |spin|
      hashed =  ScatterSwap.hash(original, spin)
      if hashed_values.include? hashed
        puts "collision: #{original} - #{spin} - #{hashed}"
        break
      end
      hashed_values.push hashed
    end
  end
end
visualize_spin
#visualize_hash
#visualize_scatter_and_unscatter
#visualize_scatter
#visualize_swapper_map
