class AdditionalFieldsToUsers < ActiveRecord::Migration
	def change
		add_column :users, :encrypted_password, :string
		add_column :users, :reset_password_token, :string
		add_column :users, :reset_password_sent_at, :datetime

		add_column :users, :remember_created_at, :datetime

		add_column :users, :sign_in_count, :integer, default: 0
		add_column :users, :current_sign_in_at, :datetime
		add_column :users, :last_sign_in_at, :datetime
		add_column :users, :current_sign_in_ip, :string
		add_column :users, :last_sign_in_ip, :string
		add_column :users, :avatar, :string

		add_column :users, :name, :string
		add_column :users, :address, :string
		add_column :users, :city, :string
		add_column :users, :zip_code, :string
		add_column :users, :phone, :string

		add_column :users, :dream_destination, :text
		add_column :users, :favorite_food, :text
		add_column :users, :favorite_restaurant, :text		
	end
end