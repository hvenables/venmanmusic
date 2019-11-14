class SearchController < ApplicationController
  def show
    if params[:search]
      @search_results = Playlist.where('name ILIKE ?', "%#{params[:search]}%")
    end
  end
end
