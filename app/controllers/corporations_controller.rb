# frozen_string_literal: true

class CorporationsController < ApplicationController
  before_action :set_corporation, only: :show
  DEFAULT_PER_PAGE = 50
  # GET /corporations
  def index
    @corporations = Corporation.where(:characters_count.gt => 0).order('name asc').page(params[:page]).per(DEFAULT_PER_PAGE)
  end

  # GET /corporations/1
  def show; end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_corporation
    @corporation = Corporation.find(params[:id].to_i)
  end

  # Only allow a trusted parameter "white list" through.
  def corporation_params
    params.fetch(:corporation, {})
  end
end
