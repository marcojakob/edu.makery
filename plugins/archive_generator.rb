# encoding: utf-8
# 
# IMPORTANT INFO:
# Most of this is a copy of the Jekyll category page generator:
# I can only use the generator for archive pages, because the category
# pages and the category feeds need rendering by other plugins (markdown
# stuff, backtick code block, url expand etc.). This does not work with
# a generator because plugins are evaluated AFTER layouts.
# see https://github.com/mojombo/jekyll/issues/225
# 
# http://recursive-design.com/projects/jekyll-plugins/
# Version: 0.1.4 (201101061053)
#
# Copyright (c) 2010 Dave Perrett, http://recursive-design.com/
# Licensed under the MIT license (http://www.opensource.org/licenses/mit-license.php)
#
# A generator that creates archive pages for jekyll sites.
#
# Included filters :
# - category_links:      Outputs the list of categories as comma-separated <a> links.
# - category_archive_links:      Outputs the list of archive categories as comma-separated <a> links.
# - date_to_html_string: Outputs the post.date as formatted html, with hooks for CSS styling.
#
# Available _config.yml settings :
# - archive_dir: The subfolder to build archive pages in (default is 'archives').

module Jekyll

  # The ArchiveIndex class creates a single archive page for the specified category.
  class ArchiveIndex < Page

    # Initializes a new ArchiveIndex.
    #
    #  +base+         is the String path to the <source>.
    #  +archive_dir+  is the String path between <source> and the category folder.
    #  +category+     is the category currently being processed.
    def initialize(site, base, archive_dir, category)
      @site = site
      @base = base
      @dir  = archive_dir
      @name = 'index.html'
      self.process(@name)
      # Read the YAML data from the layout page.
      self.read_yaml(File.join(base, '_layouts'), 'category_index.html')
      self.data['category']    = category
      # Set the title for this page.
      title_prefix             = 'Archive: '
      self.data['title']       = "#{title_prefix}#{category}"
      # Set the meta-description for this page.
      meta_description_prefix  = 'Archive: '
      self.data['description'] = "#{meta_description_prefix}#{category}"
    end

  end

  # The Site class is a built-in Jekyll class with access to global site config information.
  class Site

    # Creates an instance of ArchiveIndex for each category, renders it, and
    # writes the output to a file.
    #
    #  +archive_dir+ is the String path to the archive folder.
    #  +category+     is the category currently being processed.
    def write_archive_index(archive_dir, category)
      index = ArchiveIndex.new(self, self.source, archive_dir, category)
      index.render(self.layouts, site_payload)
      index.write(self.dest)
      # Record the fact that this page has been added, otherwise Site::cleanup will remove it.
      self.pages << index
    end

    # Loops through the list of category pages and processes each one.
    def write_archive_indexes
      if self.layouts.key? 'category_index'
        archive_dir = self.config['archive_dir'] || 'archives'
        self.categories.keys.each do |category|
          self.write_archive_index(File.join(archive_dir, category.gsub(/_|\P{Word}/, '-').gsub(/-{2,}/, '-').downcase), category)
        end

      # Throw an exception if the layout couldn't be found.
      else
        throw "No 'category_index' layout found."
      end
    end

  end


  # Jekyll hook - the generate method is called by jekyll, and generates all of the archive pages.
  class ArchiveGenerator < Generator
    safe true
    priority :low

    def generate(site)
      site.write_archive_indexes
    end

  end


  # Adds some extra filters used during the category creation process.
  module Filters

    # Outputs a list of categories as comma-separated <a> links. This is used
    # to output the category list for each post on a category page.
    #
    #  +categories+ is the list of categories to format.
    #
    # Returns string
    #
    def category_links(categories)
      dir = @context.registers[:site].config['category_dir']
      categories = categories.sort!.map do |item|
        "<a class='category' href='/#{dir}/#{item.gsub(/_|\P{Word}/, '-').gsub(/-{2,}/, '-').downcase}/'>#{item}</a>"
      end

      case categories.length
      when 0
        ""
      when 1
        categories[0].to_s
      else
        "#{categories[0...-1].join(', ')}, #{categories[-1]}"
      end
    end
    
    
    # Outputs a list of categories (for archive) as comma-separated <a> links. This is used
    # to output the category list for each post on an archive page.
    #
    #  +categories+ is the list of categories to format.
    #
    # Returns string
    #
    def category_archive_links(categories)
      dir = @context.registers[:site].config['archive_dir']
      categories = categories.sort!.map do |item|
        "<a class='category' href='/#{dir}/#{item.gsub(/_|\P{Word}/, '-').gsub(/-{2,}/, '-').downcase}/'>#{item}</a>"
      end

      case categories.length
      when 0
        ""
      when 1
        categories[0].to_s
      else
        "#{categories[0...-1].join(', ')}, #{categories[-1]}"
      end
    end

    # Outputs the post.date as formatted html, with hooks for CSS styling.
    #
    #  +date+ is the date object to format as HTML.
    #
    # Returns string
    def date_to_html_string(date)
      result = '<span class="month">' + date.strftime('%b').upcase + '</span> '
      result += date.strftime('<span class="day">%d</span> ')
      result += date.strftime('<span class="year">%Y</span> ')
      result
    end

  end

end

