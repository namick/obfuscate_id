class Post < ActiveRecord::Base
  has_many :comments

  obfuscate_id :spin => 123456789
  module Post
    def self.table_name_prefix
      'post_'
    end
  end
end
