class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :mail, null: false
      t.string :password_digest, null: false
      t.string :image
      t.string :birthday
      t.text :introduce

      t.timestamps
      t.index :mail, unique: true
    end
  end
end
