module Jekyll
  class CategoryListTag < Liquid::Tag
    def render(context)
      html = ""
      
      # add 'all' category first
      all_posts = context.registers[:site].posts.size
      all_rss_link = context.registers[:site].config['subscribe_rss']
      html << "<li class='category'><a href='/'>All (#{all_posts})</a><a title='subscribe via RSS' href='#{all_rss_link}' class='feed-rss_16 category-icon'></a></li>\n"
      
      categories = context.registers[:site].categories.keys
      categories.sort.each do |category|
        posts_in_category = context.registers[:site].categories[category].size
        category_dir = context.registers[:site].config['category_dir']
        category_url = File.join(category_dir, category.gsub(/_|\P{Word}/, '-').gsub(/-{2,}/, '-').downcase)
        rss_link = context.registers[:site].config['subscribe_rss'] + "-" + category.downcase
        html << "<li class='category'><a href='/#{category_url}/'>#{category} (#{posts_in_category})</a><a title='subscribe via RSS: #{category}' href='#{rss_link}' class='feed-rss_16 category-icon'></a></li>\n"
      end
      html
    end
  end
end

Liquid::Template.register_tag('category_list', Jekyll::CategoryListTag)