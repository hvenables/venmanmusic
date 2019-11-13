class PlaylistsController < ApplicationController
  def create
    if spotify_playlist = SpotifyPlaylist.find(id: params[:uid], user: current_user)
      playlist = Playlist.new(
        uid: spotify_playlist.id,
        name: spotify_playlist.name,
        href: spotify_playlist.href,
        user: current_user
      )
    end

    if playlist&.save
      flash[:success] = 'Playlist added'
    else
      flash[:error] = 'Error adding playlist'
    end

    redirect_to root_path
  end

  def destroy
    playlist = Playlist.find_by(id: params[:id], user: current_user)
    if playlist&.destroy
      flash[:success] = 'Playlist Removed'
    else
      flash[:error] = 'Error removing playlist'
    end

    redirect_to root_path
  end
end
