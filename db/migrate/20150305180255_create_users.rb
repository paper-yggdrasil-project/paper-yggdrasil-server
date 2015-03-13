class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :access_token
      t.string :token_type
      t.string :scope

      t.timestamps
    end
  end
end
