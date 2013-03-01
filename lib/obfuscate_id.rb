module ObfuscateId

  def obfuscate_id(options = {})
    require 'obfuscate_id/scatter_swap'
    extend ClassMethods 
    include InstanceMethods
    cattr_accessor :obfuscate_id_spin
    self.obfuscate_id_spin = (options[:spin] || obfuscate_id_default_spin)
  end

  def self.hide(id, spin)
    ScatterSwap.hash(id, spin)
  end

  def self.show(id, spin)
    ScatterSwap.reverse_hash(id, spin)
  end


  module ClassMethods
    def find(*args)
      if has_obfuscated_id?
        args[0] = ObfuscateId.show(args[0], self.obfuscate_id_spin)
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
      ObfuscateId.hide(self.id, self.class.obfuscate_id_spin)
    end

    # Temporarily set the id to the parameterized version,
    # as ActiveRecord::Persistence#reload uses self.id.
    def reload(options=nil)
      actual_id = self.id
      self.id = to_param
      super(options).tap do
        self.id = actual_id
      end
    end
  end
end

ActiveRecord::Base.extend ObfuscateId
