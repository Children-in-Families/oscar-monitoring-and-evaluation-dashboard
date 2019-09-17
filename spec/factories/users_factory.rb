FactoryBot.define do
  factory :user do
    sequence(:email)  { |n| "#{n}#{FFaker::Internet.email}" }
    first_name { FFaker::Name.first_name }
    last_name { FFaker::Name.last_name }
    roles { "viewer" }
    password { "123456789" }
    password_confirmation { "123456789" }

    trait :admin do
      roles { 'admin' }
    end
  end
end
