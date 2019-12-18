class Donor < ApplicationRecord
  has_one_attached :logo
  validates :name, :schema_name, presence: true
  validates :schema_name, uniqueness: { case_sensitive: false }
  validate :main_picture_format

  scope :active, -> { where.not(schema_name: 'mande') }

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

  private
    def main_picture_format
      return unless logo.attached?
      return if logo.blob.content_type.start_with? 'image/'
      logo.purge_later
      errors.add(:logo, 'needs to be an image')
    end
end
