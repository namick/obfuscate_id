class Post < ActiveRecord::Base
  has_many :comments

  obfuscate_id :spin => 123456789
end
