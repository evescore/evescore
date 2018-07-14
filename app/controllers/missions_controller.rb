# frozen_string_literal: true

class MissionsController < AuthController
  def index
    @characters = current_user.characters
  end

  def show
    @character = current_user.characters.find(params[:id].to_i)
  end
end
