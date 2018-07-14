# frozen_string_literal: true

desc 'Grant Awards to Characters'
task awards: :environment do
  logger = Logger.new(STDOUT)
  Character.all.each do |c|
    c.grant_awards
    logger.info "Processing Awards for: #{c.id}"
  end
end
