class CreateComments < ActiveRecord::Migration[4.2]
  def change
    create_table :comments do |t|
      t.integer :post_id
      t.string :content

      t.timestamps
    end
  end
end
