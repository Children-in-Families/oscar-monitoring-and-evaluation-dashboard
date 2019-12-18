require 'rails_helper'

RSpec.feature "Dashboards", type: :feature do
  feature 'User', js: true do
    let!(:admin){ create(:user, :admin, last_name: 'Admin', first_name: 'Admin') }
    let!(:user){ create(:user) }

    scenario 'Admin' do
      visit root_path
      page.find('.donor-logo-link').click
      within 'form#new_user' do
        fill_in 'Email', with: admin.email
        fill_in 'Password', with: "123456789"
        page.find("input[type='submit']").click
      end

      expect(page).to have_content('Users')
      expect(page).to have_content('Clients')
      expect(page).to have_content('Changelogs')
      expect(page).to have_selector 'iframe'
    end

    scenario 'Viewer' do
      logout admin
      visit root_path
      page.find('.donor-logo-link').click
      within 'form#new_user' do
        fill_in 'Email', with: user.email
        fill_in 'Password', with: "123456789"
        page.find("input[type='submit']").click
      end

      expect(page).to have_content('Clients')
      expect(page).to_not have_content('Users')
      expect(page).to_not have_content('Changelogs')
      expect(page).to have_selector 'iframe'
    end
  end
end
