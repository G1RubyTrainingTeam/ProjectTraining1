class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable,
    :omniauthable, omniauth_providers: %i[facebook google_oauth2]

  has_many :comments, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_many :courses, dependent: :destroy

  enum role: {guest: 0, student: 1, lecture: 2, admin: 3}

  class << self
    def from_omniauth(auth)
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.email = auth.info.email
        user.provider = auth.provider
        user.uid = auth.uid
        user.password = Devise.friendly_token[0,20]
      end
    end
  end
end
