require 'rails_helper'

RSpec.feature "Users", type: :feature do
  let!(:admin){ create(:user, :admin, last_name: 'Admin', first_name: 'Admin') }
  let!(:user){ create(:user) }

  feature 'List' do
    before do
      login_as(admin)
    end

    scenario 'Users', js: true do
      visit users_path

      expect(page).to have_content('Admin')
      expect(page).to have_content('2 entries')
    end
  end
end
