# frozen_string_literal: true

class CharacterAward
  include Mongoid::Document
  belongs_to :character
  belongs_to :award
end
