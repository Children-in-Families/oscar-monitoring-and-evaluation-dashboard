FactoryBot.define do
  factory :donor do
    name { FFaker::Company.name }
    schema_name { FFaker::Name.last_name.downcase }
    iframe_link { FFaker::Internet.domain_name }

    after :create do |donor|
      Apartment::Tenant.create(donor.schema_name)
      donor.logo.attach(io: File.open(Rails.root.join('app/assets/images/sci_logo.png')), filename: 'sci_logo.png')
      Donor.switch_to donor.schema_name
      create(:user, :admin, last_name: 'Admin', first_name: 'Admin')
      create(:user)
    end
  end
end
