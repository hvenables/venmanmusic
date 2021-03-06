class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:spotify]

  has_many :playlists
  has_many :messages, foreign_key: :recipient_id
  has_many :sent_messages, foreign_key: :sender_id

  def self.from_omniauth(auth)
    user = find_or_create_by(uid: auth.uid) do |user|
      user.uid = auth.uid
      user.email = auth.info.email
      user.name = auth.info.name
      user.country_code = auth.info.country_code
      user.href = auth.extra.raw_info.href
      user.password = Devise.friendly_token[0, 20]
    end

    user.update(
      access_token: auth.credentials.token,
      token_expires_at: Time.at(auth.credentials.expires_at),
      refresh_token: auth.credentials.refresh_token
    )

    user
  end

  def spotify_info
    renew_access_token

    response = HTTParty.get(
      'https://api.spotify.com/v1/me',
      headers: { 'Authorization' => "Bearer #{access_token}" }
    )

    update_user_info(
      followers: response.dig('followers', 'total'),
      image: response.dig('images', 0, 'url'),
      name: response['display_name']
    )

    response
  end

  def spotify_playlists(page: 1, per: 25)
    SpotifyPlaylist.find_by_user(user: self, page: page, per: per)
  end

  def renew_access_token
    return if token_expires_at > Time.now

    response = HTTParty.post(
      'https://accounts.spotify.com/api/token',
      body: {
        grant_type: 'refresh_token',
        refresh_token: refresh_token
      },
      headers: {
        'Authorization' => app_authorization_token
      }
    )

    update!(
      access_token: response['access_token'],
      token_expires_at: Time.now + response['expires_in'].seconds
    )
  end

  def app_authorization_token
    <<-TOKEN.squish
      Basic #{Base64.strict_encode64(
        Rails.application.credentials.spotify[:client_id] +
        ':' +
        Rails.application.credentials.spotify[:client_secret]
      )}
    TOKEN
  end

  private

  def update_user_info(followers:, image:, name:)
    update(
      name: name,
      followers: followers,
      image: image
    )
  end
end
