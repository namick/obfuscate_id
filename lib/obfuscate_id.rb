module ObfuscateId

  def obfuscate_id(options = {})
    require 'obfuscate_id/scatter_swap'
    extend ClassMethods 
    include InstanceMethods
    cattr_accessor :obfuscate_id_spin
    self.obfuscate_id_spin = (options[:spin] || obfuscate_id_default_spin)
  end

  def self.hide(id)
    ScatterSwap.hash(id)
  end

  def self.show(id)
    ScatterSwap.reverse_hash(id)
  end


  module ClassMethods
    def find(*args)
      if has_obfuscated_id?
        args[0] = ObfuscateId.show(args[0])
      end
      super(*args)
    end

    def has_obfuscated_id?
      true
    end

    # Generate a default spin from the Model name
    # This makes it easy to drop obfuscate_id onto any model
    # and produce different obfuscated ids for different models
    def obfuscate_id_default_spin
      alphabet = Array("a".."z") 
      number = name.split("").collect do |char|
        alphabet.index(char)
      end
      number.join.to_i
    end

  end

  module InstanceMethods
    def to_param
      ObfuscateId.hide(self.id)
    end

  end
end

ActiveRecord::Base.extend ObfuscateId
