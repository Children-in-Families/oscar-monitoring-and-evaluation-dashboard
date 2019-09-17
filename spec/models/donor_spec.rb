require 'rails_helper'

RSpec.describe Donor, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:schema_name) }
    it { should validate_uniqueness_of(:schema_name).case_insensitive }
  end
end
