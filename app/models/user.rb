class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable
  ROLES = ['admin', 'guest'].freeze

  has_paper_trail on: %i[create destroy touch update]

  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :last_name, :first_name, presence: true
  validates :roles, inclusion: { in: ROLES }

  has_many :changelogs, dependent: :restrict_with_error

  ROLES.each do |role|
    define_method("#{role.parameterize.underscore}?") do
      roles == role
    end
  end

  def name
    full_name = "#{first_name} #{last_name}"
    full_name.present? ? full_name : 'Unknown'
  end

  def destroy
    update_attributes(deactivated: true) unless deactivated
  end

  def active_for_authentication?
    super && !deactivated
  end
end
