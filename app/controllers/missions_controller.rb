# frozen_string_literal: true

class MissionsController < AuthController
  before_action :set_character, except: %i[index]
  skip_before_action :authenticate_user!, if: :character_public?, except: :index
  before_action :check_owner, unless: :character_public?, except: :index

  def index
    @characters = current_user.characters
  end

  def show; end

  protected

  def set_character
    @character = Character.find(params[:id].to_i)
  end

  def check_owner
    current_user.characters.include?(@character) || redirect_to(root_path, notice: "You don't have access to this character")
  end

  def character_public?
    return false if params[:action] == 'index'
    set_character.display_option == 'Public'
  end
end
