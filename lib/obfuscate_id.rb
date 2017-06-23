module ObfuscateId
  def obfuscate_id(options = {})
    require 'scatter_swap'

    extend ClassMethods
    include InstanceMethods
    cattr_accessor :obfuscate_id_spin, :obfuscater # Obfuscater, aka the ScatterSwapper for this spin
    self.obfuscate_id_spin = (options[:spin] || obfuscate_id_default_spin)
    self.obfuscater = ScatterSwap::Hasher.new(self.obfuscate_id_spin)
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
          scope.map! {|a| deobfuscated_id(a).to_i}
        else
          scope = deobfuscated_id(scope)
        end
      end
      super(scope)
    end

    def has_obfuscated_id?
      true
    end

    def deobfuscated_id(obfuscated_id)
      self.obfuscater.reverse_hash(obfuscated_id)
    end
    alias_method :deobfuscate_id, :deobfuscated_id

    def obfuscated_id(plain_id)
      self.obfuscater.hash(plain_id)
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
      self.class.obfuscated_id(self.id)
    end

    # Override ActiveRecord::Persistence#reload
    # passing in an options flag with { no_obfuscated_id: true }
    def reload(options = nil)
      options = (options || {}).merge(no_obfuscated_id: true)

      clear_aggregation_cache
      clear_association_cache

      fresh_object =
        if options && options[:lock]
          self.class.unscoped { self.class.lock(options[:lock]).find(id, options) }
        else
          self.class.unscoped { self.class.find(id, options) }
        end

      @attributes = fresh_object.instance_variable_get('@attributes')
      @new_record = false
      self
    end

    def deobfuscated_id(obfuscated_id)
      self.class.deobfuscated_id(obfuscated_id)
    end
    alias_method :deobfuscate_id, :deobfuscated_id
  end
end

ActiveRecord::Base.extend ObfuscateId
