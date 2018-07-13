# frozen_string_literal: true

class PagesController < ApplicationController
  def legal; end

  def stats; end

  def info; end

  def changes
    render html: Kramdown::Document.new(File.read('CHANGES.md'))
  end
end
