# frozen_string_literal: true

module MongoidSetup
  extend ActiveSupport::Concern
  include Mongoid::Document
  include Mongoid::Timestamps
  include GlobalID::Identification
end
