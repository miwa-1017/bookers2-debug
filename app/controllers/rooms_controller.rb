class RoomsController < ApplicationController
  before_action :authenticate_user!

  def create
    existing_room = Room.joins(:entries)
                        .where(entries: { user_id: current_user.id })
                        .merge(Entry.where(user_id: params[:user_id]))
                        .first
    if existing_room
      redirect_to room_path(existing_room)     
    else
      room = Room.create
      Entry.create(room_id: room.id, user_id: current_user.id)
      Entry.create(room_id: room.id, user_id: params[:user_id])
      redirect_to room_path(room)
    end
  end

  def show
    @room = Room.find(params[:id])
    if Entry.where(user_id: current_user.id, room_id: @room.id).present?
      @messages = @room.messages
      @message = Message.new
      @entries = @room.entries
    else
      redirect_back(fallback_location: root_path)
    end
  end
end
