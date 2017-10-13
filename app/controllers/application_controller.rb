# frozen_string_literal: true

class ApplicationController < ActionController::Base
  layout :choose_layout

  def choose_layout
    if devise_controller?
      'bare'
    else
      'application'
    end
  end

  protected

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || characters_path
  end
end
