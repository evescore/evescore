# frozen_string_literal: true

class PagesController < ApplicationController
  def legal; end

  def stats; end

  def info; end

  def changes
    render html: Kramdown::Document.new(File.read('CHANGES.md')).to_html.html_safe, layout: 'changelog'
  end
end
