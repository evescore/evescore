# frozen_string_literal: true

class WelcomeController < ApplicationController
  before_action :top_isk, only: :index
  before_action :top_ticks, only: :index
  before_action :top_average_ticks, only: :index
  before_action :total_isk, only: :index
  before_action :total_tax, only: :index
  before_action :total_kills, only: :index
  before_action :total_ded_sites, only: :index
  before_action :total_missions, only: :index
  before_action :corporations_top_isk, only: :index
  before_action :corporations_top_tax, only: :index
  before_action :public_top_ded_sites, only: :index
  before_action :public_top_missions, only: :index
  before_action :public_top_kills, only: :index

  DEFAULT_PER_PAGE = 10

  def index; end

  def ticks
    @top_ticks = WalletRecord.public_top_ticks.page(params[:page]).per(DEFAULT_PER_PAGE)
  end

  def average_ticks
    @top_ticks = Kaminari.paginate_array(WalletRecord.public_top_average_ticks.to_a).page(params[:page]).per(DEFAULT_PER_PAGE)
  end

  def isk
    @top_isk = Kaminari.paginate_array(WalletRecord.public_top_isk.to_a).page(params[:page]).per(DEFAULT_PER_PAGE)
    head :ok
  end

  def tick
    @tick = WalletRecord.public_records.find(params[:tick_id])
  end

  private

  def top_isk
    @top_isk = WalletRecord.public_top_isk(5)
  end

  def top_ticks
    @top_ticks = WalletRecord.public_top_ticks.limit(5)
  end

  def top_average_ticks
    @top_average_ticks = WalletRecord.public_top_average_ticks(5)
  end

  def total_isk
    @total_isk = WalletRecord.all.sum(:amount)
  end

  def total_tax
    @total_tax = WalletRecord.all.sum(:tax)
  end

  def total_kills
    @total_kills = Kill.all.sum(:amount)
  end

  def total_ded_sites
    @total_ded_sites = WalletRecord.where(:ded_site.ne => nil).count
  end

  def total_missions
    @total_missions = WalletRecord.where(:mission_level.ne => nil).count
  end

  def corporations_top_isk
    @corporations_top_isk = WalletRecord.corporations_top_isk(5)
  end

  def corporations_top_tax
    @corporations_top_tax = WalletRecord.corporations_top_tax(5)
  end

  def public_top_ded_sites
    @public_top_ded_sites = WalletRecord.public_top_ded_sites
  end

  def public_top_missions
    @public_top_missions = WalletRecord.public_top_missions(5)
  end

  def public_top_kills
    @public_top_kills = Kill.public_top(5)
  end
end
