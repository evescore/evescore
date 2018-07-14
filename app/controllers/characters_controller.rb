# frozen_string_literal: true

class CharactersController < AuthController
  before_action :set_character, except: :index
  skip_before_action :authenticate_user!, if: :character_public?
  before_action :check_owner, unless: :character_public?, except: :index

  DEFAULT_PER_PAGE = 10

  def index
    @characters = current_user.characters || []
  end

  def profile
    @ticks = @character.wallet_records.order('ts desc').limit(5)
    @earnings_by_day = @character.earnings_by_day(5)
    @valuable_rats = @character.kills_by_bounty(5)
    @top_ticks = @character.wallet_records.order('amount desc').limit(5)
  end

  def earnings
    @earnings_by_day = Kaminari.paginate_array(@character.earnings_by_day.to_a).page(params[:page]).per(DEFAULT_PER_PAGE)
  end

  def ticks
    @top_ticks = @character.wallet_records.order('amount desc').page(params[:page]).per(DEFAULT_PER_PAGE)
  end

  def rats
    @valuable_rats = Kaminari.paginate_array(@character.kills_by_bounty.to_a).page(params[:page]).per(DEFAULT_PER_PAGE)
  end

  def journal
    @ticks = @character.wallet_records.order('ts desc').page(params[:page]).per(DEFAULT_PER_PAGE)
  end

  def destroy
    @character.destroy
    redirect_to characters_path, notice: 'Character removed'
  end

  def display_option
    redirect_to characters_path, alert: 'Something went wrong with display option change' && return unless @character.update(character_params)
    redirect_to characters_path, notice: "Display option for #{@character.name} now set to #{character_params[:display_option]}"
  end

  protected

  def check_owner
    current_user.characters.include?(@character) || redirect_to(root_path, notice: "You don't have access to this character")
  end

  def set_character
    @character = Character.find(params[:character_id].to_i)
  end

  def character_params
    params.require(:character).permit(:display_option)
  end

  def character_public?
    return if params[:action] == 'index'
    set_character.display_option == 'Public'
  end
end
