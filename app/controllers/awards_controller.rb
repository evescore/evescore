# frozen_string_literal: true

class AwardsController < AuthController
  before_action :set_character
  skip_before_action :authenticate_user!, if: :character_public?
  before_action :check_owner, unless: :character_public?

  def show; end

  protected

  def check_owner
    current_user.characters.include?(@character) || redirect_to(root_path, notice: "You don't have access to this character")
  end

  def set_character
    @character = Character.find(params[:character_id].to_i)
  end

  def character_public?
    set_character.display_option == 'Public'
  end
end
