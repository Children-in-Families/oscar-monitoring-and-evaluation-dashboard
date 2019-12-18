require 'rails_helper'

RSpec.feature "Donors", type: :feature do
  feature 'Landing page' do
    scenario 'List donors' do
      visit root_path

      expect(page).to have_selector 'a.donor-logo-link'
    end
  end
end
