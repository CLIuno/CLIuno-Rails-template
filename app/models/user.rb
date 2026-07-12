class User < ApplicationRecord
  has_secure_password

  belongs_to :role, optional: true
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :todos, dependent: :destroy
  has_many :active_follows, class_name: "Follow", foreign_key: :follower_id, dependent: :destroy
  has_many :passive_follows, class_name: "Follow", foreign_key: :following_id, dependent: :destroy
  has_many :following_users, through: :active_follows, source: :following
  has_many :follower_users, through: :passive_follows, source: :follower

  validates :username, presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone, uniqueness: true, allow_nil: true, allow_blank: true
  validates :password, length: { minimum: 6 }, if: -> { new_record? || password.present? }

  scope :active, -> { where(is_deleted: false) }

  def admin?
    role&.name == "admin"
  end

  def soft_delete!
    update!(is_deleted: true, deleted_at: Time.current)
  end

  def as_json(options = {})
    options = options.dup
    options[:except] = Array(options[:except]) | %i[password_digest refresh_token]
    super(options)
  end
end
