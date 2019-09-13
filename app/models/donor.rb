class Donor < ApplicationRecord

  validates :name, :schema_name, presence: true
  validates :schema_name, uniqueness: { case_sensitive: false }

  class << self
    def current
      find_by(schema_name: Apartment::Tenant.current)
    end

    def switch_to(tenant_name)
      Apartment::Tenant.switch!(tenant_name)
    end

    def create_and_build_tanent(fields = {})
      transaction do
        org = create(fields)
        Apartment::Tenant.create(fields[:schema_name])
        org
      end
    end
  end
end
