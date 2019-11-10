class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:spotify]

  def self.from_omniauth(auth)
    find_or_create_by(uid: auth.uid) do |user|
      user.uid = auth.uid
      user.email = auth.info.email
      user.name = auth.info.name
      user.country_code = auth.info.country_code
      user.href = auth.extra.raw_info.href
      user.password = Devise.friendly_token[0, 20]
    end
  end
end
