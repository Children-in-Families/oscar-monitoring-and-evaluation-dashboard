class AddFieldsToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :first_name,     :string, default: ''
    add_column :users, :last_name,      :string, default: ''
    add_column :users, :roles,          :string, default: 'guest'
    add_column :users, :gender,         :string, default: ''
    add_column :users, :job_title,      :string, default: ''
    add_column :users, :date_of_birth,  :date
  end
end
