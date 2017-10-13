# frozen_string_literal: true

class GlobalID
  module Locator
    class BaseLocator
      def locate(gid)
        model_id = gid.model_id.i? ? gid.model_id.to_i : gid.model_id
        gid.model_class.find model_id
      end
    end
  end
end
