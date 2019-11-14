class MessagesController < ApplicationController
  def index
    @messages = current_user.messages.order(created_at: :desc)
  end

  def new
    @playlist = Playlist.find(params[:playlist_id])
    @message = Message.new(playlist_id: params[:playlist_id])
  end

  def create
    playlist = Playlist.find(message_params[:playlist_id])
    message = Message.new(
      sender: current_user,
      recipient: playlist.user,
      playlist: playlist,
      message: message_params[:message]
    )

    if message.save
      flash[:success] = 'Message Sent'
      redirect_to root_path
    else
      flash[:error] = 'Messafe not sent'
      render :new
    end
  end

  private

  def message_params
    params.require(:message).permit(:playlist_id, :message)
  end
end
