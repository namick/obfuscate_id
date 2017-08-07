class CreatePostSubPosts < ActiveRecord::Migration[5.1]
  def change
    create_table :post_sub_posts do |t|
      t.string :content
      t.timestamps
    end
  end
end
