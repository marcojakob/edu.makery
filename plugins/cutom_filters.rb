module CustomLiquidFilters
  
  # removes the line numbers (helpful for rss feeds)
  def remove_linenumbers(input)
    input.gsub(/\<td\ class="gutter"\>.+?\<\/td\>/m, ' ')
  end
end

Liquid::Template.register_filter CustomLiquidFilters