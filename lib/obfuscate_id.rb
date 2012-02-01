module ObfuscateId

  def obfuscate_id
    extend ClassMethods 
    include InstanceMethods
  end

  def self.hide(id)
    id.to_i + 100
  end

  def self.show(id)
    id.to_i - 100
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
  end

  module InstanceMethods
    def to_param
      ObfuscateId.hide(self.id)
    end

  end
end

ActiveRecord::Base.extend ObfuscateId
