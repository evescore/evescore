# frozen_string_literal: true

class Charge
  include MongoidSetup
  include ApiAttributes
  field :name, type: String
  field :description, type: String

  alias charge_attributes api_attributes
end
