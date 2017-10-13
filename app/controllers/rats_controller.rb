# frozen_string_literal: true

class RatsController < ApplicationController
  before_action :set_rat
  before_action :set_attributes
  before_action :set_missile_attributes, only: :show

  def show
  rescue Mongoid::Errors::DocumentNotFound
    head :not_found
  end

  def set_rat
    @rat = Rat.find(params[:id].to_i)
  end

  def set_attributes
    @attributes = begin
                    Rats::Attributes.new(@rat.rat_attributes)
                  rescue Mongoid::Errors::DocumentNotFound
                    Rats::Attributes.new({})
                  end
  end

  def set_missile_attributes
    @missile_attributes = begin
                            Charges::Attributes.new(Charge.find(@attributes.entity_missile_type_id.value.to_i).charge_attributes)
                          rescue StandardError
                            nil
                          end
  end

  def details; end
end
