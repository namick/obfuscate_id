class Post < ActiveRecord::Base
  has_many :comments

  obfuscate_id
end
