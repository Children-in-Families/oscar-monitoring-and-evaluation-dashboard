class CreateDonors < ActiveRecord::Migration[6.0]
  def change
    create_table :donors do |t|
      t.string :name, default: '', index: { unique: true }
      t.string :schema_name, default: ''
      t.string :iframe_link, default: ''
      t.string :logo

      t.timestamps
    end
  end
end
