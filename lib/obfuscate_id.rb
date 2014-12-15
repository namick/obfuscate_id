module ObfuscateId

  def obfuscate_id(options = {})
    require 'scatter_swap'

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
      scope = args.slice!(0)
      options = args.slice!(0) || {}
      if has_obfuscated_id? && !options[:no_obfuscated_id]
        if scope.is_a?(Array)
          scope.map! {|a| deobfuscate_id(a).to_i}
        else
          scope = deobfuscate_id(scope)
        end
      end
      super(scope)
    end

    def has_obfuscated_id?
      true
    end

    def deobfuscate_id(obfuscated_id)
      ObfuscateId.show(obfuscated_id, self.obfuscate_id_spin)
    end

    # Generate a default spin from the Model name
    # This makes it easy to drop obfuscate_id onto any model
    # and produce different obfuscated ids for different models
    def obfuscate_id_default_spin
      alphabet = Array("a".."z") 
      number = name.split("").collect do |char|
        alphabet.index(char)
      end
      number.shift(12).join.to_i
    end

  end

  module InstanceMethods
    def to_param
      ObfuscateId.hide(self.id, self.class.obfuscate_id_spin)
    end

    # As ActiveRecord::Persistence#reload uses self.id
    # reload without deobfuscating
    def reload(options = nil)
      options = (options || {}).merge(:no_obfuscated_id => true)
      self.id = self.to_param
      super(options)
    end

    def deobfuscate_id(obfuscated_id)
      self.class.deobfuscate_id(obfuscated_id)
    end
  end
end

ActiveRecord::Base.extend ObfuscateId
