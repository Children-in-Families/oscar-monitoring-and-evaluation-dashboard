class AddFieldsToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :first_name,     :string, default: ''
    add_column :users, :last_name,      :string, default: ''
    add_column :users, :roles,          :string, default: 'viewer'
    add_column :users, :deactivated,    :boolean, default: false
    add_column :users, :activated_at,   :datetime
    add_column :users, :deactivated_at, :datetime
  end
end
