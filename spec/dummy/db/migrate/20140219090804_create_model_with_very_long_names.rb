class CreateModelWithVeryLongNames < ActiveRecord::Migration
  def change
    create_table :model_with_very_long_names do |t|

      t.timestamps
    end
  end
end
