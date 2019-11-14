class SpotifyPlaylist
  def initialize(id:, name:, href:, image:, private_playlist:)
    @id = id
    @name = name
    @href = href
    @image = image
    @private_playlist = private_playlist
  end

  attr_reader :id, :name, :href, :images, :private_playlist

  def self.find_by_user(user:, page: 1, per: 25)
    user.renew_access_token

    response = HTTParty.get(
      "https://api.spotify.com/v1/me/playlists",
      query: { offset: (page - 1) * per, limit: per },
      headers: { 'Authorization': "Bearer #{user.access_token}" }
    )

    response['items'].map do |playlist_info|
      new(
        id: playlist_info['id'],
        name: playlist_info['name'],
        href: playlist_info['href'],
        image: playlist_info['images'].first,
        private_playlist: !playlist_info['public']
      )
    end
  end

  def self.find(id:, user:)
    user.renew_access_token

    playlist = HTTParty.get(
      "https://api.spotify.com/v1/playlists/#{id}",
      headers: { 'Authorization': "Bearer #{user.access_token}" }
    )

    return false if playlist['owner']['id'] != user.uid

    new(
      id: playlist['id'],
      name: playlist['name'],
      href: playlist['href'],
      image: playlist['images'].first,
      private_playlist: !playlist['public']
    )
  end
end
