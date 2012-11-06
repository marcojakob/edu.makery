module Jekyll

  class CategoryPagination < Generator

    # Generate paginated pages if necessary.
    #
    # site - The Site.
    #
    # Returns nothing.
    def generate(site)
      site.pages.dup.each do |page|
        
        if CategoryPager.pagination_enabled?(site.config, page)
          paginateCategory(site, page, page.data['category'])
        elsif Pager.pagination_enabled?(site.config, page)
          paginate(site, page)
        end
      end
    end
    
    # Copy from pagination.rb
    # Paginates the blog's posts. Renders the index.html file into paginated
    # directories, e.g.: page2/index.html, page3/index.html, etc and adds more
    # site-wide data.
    #
    # site - The Site.
    # page - The index.html Page that requires pagination.
    #
    # {"paginator" => { "page" => <Number>,
    #                   "per_page" => <Number>,
    #                   "posts" => [<Post>],
    #                   "total_posts" => <Number>,
    #                   "total_pages" => <Number>,
    #                   "previous_page" => <Number>,
    #                   "next_page" => <Number> }}
    def paginate(site, page)
      all_posts = site.site_payload['site']['posts']
      pages = Pager.calculate_pages(all_posts, site.config['paginate'].to_i)
      page_dir = page.destination('').sub(/\/[^\/]+$/, '')
      page_dir_config = site.config['pagination_dir']
      dir = ((page_dir_config || page_dir) + '/').sub(/^\/+/, '')

      (1..pages).each do |num_page|
        pager = Pager.new(site.config, num_page, all_posts, page_dir+'/', '/'+dir, pages)
        if num_page > 1
          newpage = Page.new(site, site.source, page_dir, page.name)
          newpage.pager = pager
          newpage.dir = File.join(page.dir, "#{dir}page/#{num_page}")
          site.pages << newpage
        else
          page.pager = pager
        end
      end
    end
    
    # Paginates the blog's posts for a CATEGORY. Renders the index.html file into paginated
    # directories, e.g.: page2/index.html, page3/index.html, etc and adds more
    # site-wide data.
    #
    # site - The Site.
    # page - The index.html Page that requires pagination.
    #
    # {"paginator" => { "page" => <Number>,
    #                   "per_page" => <Number>,
    #                   "posts" => [<Post>],
    #                   "total_posts" => <Number>,
    #                   "total_pages" => <Number>,
    #                   "previous_page" => <Number>,
    #                   "next_page" => <Number> }}
    def paginateCategory(site, page, category)
      # get posts of category
      category_posts = site.categories[category].sort_by { |p| -p.date.to_f }
      # calculate total number of pages
      pages = Pager.calculate_pages(category_posts, site.config['paginate'].to_i)
      page_dir = page.destination('').sub(/\/[^\/]+$/, '')
      dir = (page_dir + '/').sub(/^\/+/, '')

      # iterate over total number of pages and create a physical page for each
      (1..pages).each do |num_page|
        pager = CategoryPager.new(site.config, num_page, category_posts, page_dir+'/', '/'+dir, pages)
        if num_page > 1
          newpage = Page.new(site, site.source, page_dir, page.name)
          newpage.pager = pager
          newpage.dir = File.join(page.dir, "#{dir}page/#{num_page}")
          site.pages << newpage
        else
          page.pager = pager
        end
      end
    end
  end

  class CategoryPager < Pager
    
    def self.pagination_enabled?(config, page)
      page.name == 'index.html' && !config['paginate'].nil? && page.data.key?('category') && page.content =~ /paginator\./
    end
 
  end

end

