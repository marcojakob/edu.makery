module RSSUrlFilter

  # creates an rss url from the subscribe_rss config. 
  # If there is a category specified in the page, the category is 
  # appended with a '-' to the subscribe_rss url
  def rss_url(page)
    if page['category']
      @context.registers[:site].config['subscribe_rss'] + "-" + page['category'].downcase
    else
      @context.registers[:site].config['subscribe_rss']
    end
  end

end

Liquid::Template.register_filter RSSUrlFilter