class CreateLimits < ActiveRecord::Migration[6.1]
  def change
    create_table :limits do |t|
      t.integer :admin_id
      t.string :word
      t.timestamps
    end
  end
end
