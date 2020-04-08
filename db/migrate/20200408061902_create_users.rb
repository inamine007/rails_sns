class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :mail
      t.string :password_digest
      t.string :image
      t.string :birthday
      t.text :introduce

      t.timestamps
    end
  end
end
