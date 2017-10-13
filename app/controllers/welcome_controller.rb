# frozen_string_literal: true

class WelcomeController < ApplicationController
  DEFAULT_PER_PAGE = 10

  def index
    @top_isk = WalletRecord.public_top_isk(5)
    @top_ticks = WalletRecord.public_top_ticks.limit(5)
    @top_average_ticks = WalletRecord.public_top_average_ticks(5)
  end

  def ticks
    @top_ticks = WalletRecord.public_top_ticks.page(params[:page]).per(DEFAULT_PER_PAGE)
  end

  def average_ticks
    @top_average_ticks = Kaminari.paginate_array(WalletRecord.public_top_average_ticks.to_a).page(params[:page]).per(DEFAULT_PER_PAGE)
    head :ok
  end

  def isk
    @top_isk = Kaminari.paginate_array(WalletRecord.public_top_isk.to_a).page(params[:page]).per(DEFAULT_PER_PAGE)
    head :ok
  end
end
