class SpotifySearcher
  def initialize
    @access_token = credentials
  end

  def perform(term, type)
    HTTParty.get(
      "https://api.spotify.com/v1/search?q=#{term}&type=#{type}",
      headers: { 'Authorization' => 'Bearer ' +  access_token }
    ).parsed_response['artists']['items'].map { |a| a['name'] }
  end

  private

  attr_reader :access_token

  def credentials
    HTTParty.post(
      'https://accounts.spotify.com/api/token',
      body: { grant_type: 'client_credentials' },
      headers: {
        'Authorization' => 'Basic ' + Base64.strict_encode64("#{client_id}:#{client_secret}")
      }
    ).parsed_response['access_token']
  end

  def client_id
    Rails.application.credentials.spotify[:client_id]
  end

  def client_secret
    Rails.application.credentials.spotify[:client_secret]
  end
end
