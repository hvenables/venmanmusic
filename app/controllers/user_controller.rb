class UserController < ApplicationController
  def show
    @user = current_user
    @playlists = @user.spotify_playlists(page: params[:page]&.to_i || 1, per: params[:per]&.to_i || 25)
    @my_playlists = @user.playlists
  end
end
