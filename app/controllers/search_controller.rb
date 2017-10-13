# frozen_string_literal: true

class SearchController < ApplicationController
  include ImageHelper
  include ActionView::Helpers::AssetTagHelper
  def search
    head(:ok) && return if params[:query].blank?
    @rats = Rat.where(name: /#{params[:query]}/i).map { |r| { id: r.id, name: r.name, path: rats_path(r), image: type_image_path(r.id) } }
    render json: @rats
  end
end
