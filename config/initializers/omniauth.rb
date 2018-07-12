# frozen_string_literal: true

module OmniAuth
  module Strategies
    class ESI < OmniAuth::Strategies::Crest
      option :name, :esi
      option :authorize_options, %i[scope state redirect_uri]

      def callback_url
        options[:redirect_uri] || (full_host + script_name + callback_path)
      end
    end
  end
end
