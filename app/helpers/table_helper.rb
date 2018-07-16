# frozen_string_literal: true

module TableHelper
  def top_table(object, options)
    render partial: 'shared/top_table', object: object, locals: top_table_locals(options)
  end

  def top_table_locals(options)
    {
      caption: options[:caption], more: options[:more], subject: options[:subject].capitalize,
      value: options[:value].capitalize, subject_image_link: top_table_image_link(options[:subject]),
      subject_field: options[:subject_field], value_field: options[:value_field],
      subject_link: top_table_link(options[:subject]), value_display: options[:value_display]
    }
  end

  def top_table_link(symbol)
    (symbol.to_s + '_link').to_sym
  end

  def top_table_image_link(symbol)
    (symbol.to_s + '_image_link').to_sym
  end

  def top_table_caption(caption, more = false)
    content_tag(:caption) do
      caption ||= ''
      concat caption
      concat(content_tag(:span, link_to('More', more), class: 'pull-right')) if more
      corporations_isk_path
    end
  end

  def top_table_head(subject, value)
    ths = content_tag(:th, '', class: 'icon') + content_tag(:th, subject) + content_tag(:th, value, class: 'numeric')
    content_tag(:thead, content_tag(:tr, ths))
  end

  def top_table_row(record, options = {})
    size = options[:size] || 32
    spo icon = content_tag(:td, send(options[:subject_image_link], record[options[:subject_field]], size))
    subject = content_tag(:td, send(options[:subject_link], record[options[:subject_field]]))
    value = content_tag(:td, send(options[:value_display], record[options[:value_field]]), class: 'numeric')
    content_tag(:tr, icon + subject + value)
  end
end
