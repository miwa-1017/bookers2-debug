class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    @message = current_user.messages.new(message_params)
    @room = @message.room
    @messages = @room.messages
    @entries = @room.entries

    if @message.save
      redirect_to room_path(@message.room)
    else
      render "rooms/show"
    end
  end

  private

  def message_params

params.require(:message).permit(:content, :room_id)
  end
end
