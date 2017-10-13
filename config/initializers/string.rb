# frozen_string_literal: true

class String
  def number?
    true if Float(self)
  rescue ArgumentError
    false
  end

  def i?
    /\A[-+]?\d+\z/ =~ self
  end

  unless method_defined? :match?
    def matcha?(pattern)
      match(pattern) || false
    end
  end
end
