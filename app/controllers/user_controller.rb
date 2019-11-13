class UserController < ApplicationController
  def show
    @user = current_user
    @playlists = @user.spotify_playlists(page: params[:page] || 1, per: params[:per] || 25)
    @my_playlists = @user.playlists
  end
end
