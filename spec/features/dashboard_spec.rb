require 'rails_helper'

RSpec.feature "Dashboards", type: :feature do
  let!(:admin){ create(:user, :admin, last_name: 'Admin', first_name: 'Admin') }
  let!(:user){ create(:user) }

  feature 'User' do
    scenario 'Admin', js: true do
      login_as(admin)
      visit root_path

      expect(page).to have_content('Users')
      expect(page).to have_content('Changelogs')
      expect(page).to have_selector 'iframe'
    end

    scenario 'Viewer', js: true do
      logout admin
      login_as(user)
      visit root_path

      expect(page).to have_content('Clients')
      expect(page).to_not have_content('Users')
      expect(page).to_not have_content('Changelogs')
      expect(page).to have_selector 'iframe'
    end
  end
end
