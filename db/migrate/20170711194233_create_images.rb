class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :caption
      t.integer :creator_id, {null:false}

      t.timestamps null: false
    end
  end
end
