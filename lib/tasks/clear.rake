# frozen_string_literal: true

namespace :clear do
  desc 'Clear Rat, WallerRecord and Kill records'
  task all: :environment do
    clear_rats
    clear_wallets
    clear_kills
  end

  desc 'Clear Rat records'
  task rats: :environment do
    clear_rats
  end

  desc 'Clear WallerRecords'
  task wallets: :environment do
    clear_wallets
  end

  desc 'Clear Kill records'
  task kills: :environment do
    clear_kills
  end
end

def logger
  Logger.new(STDOUT)
end

def clear_rats
  logger.info 'Deleting Rats'
  Rat.delete_all
end

def clear_wallets
  logger.info 'Deleting WalletRecords'
  WalletRecord.delete_all
end

def clear_kills
  logger.info 'Deleting Kills'
  Kill.delete_all
end
