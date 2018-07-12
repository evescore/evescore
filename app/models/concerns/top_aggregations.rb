# frozen_string_literal: true

module TopAggregations
  extend ActiveSupport::Concern

  class_methods do
    def public_records
      where(:character_id.in => Character.public_characters.map(&:id))
    end

    def aggregate_public_top_pipeline(query, limit)
      pipeline = query.pipeline
      pipeline.push('$limit' => limit) if limit
      collection.aggregate pipeline
    end
  end
end
