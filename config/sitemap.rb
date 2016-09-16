# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://minecraft-pe-servers.com"

SitemapGenerator::Sitemap.create do

  #store on S3 using Fog (pass in configuration values as shown above if needed)
  SitemapGenerator::Sitemap.adapter = SitemapGenerator::S3Adapter.new
# inform the map cross-linking where to find the other maps
  SitemapGenerator::Sitemap.sitemaps_host = "http://#{ENV['FOG_DIRECTORY']}.s3.amazonaws.com/"


  SitemapGenerator::Sitemap.create do

    add 'tos', :changefreq => 'monthly', :priority => 0.7
    add 'about', :changefreq => 'monthly', :priority => 0.7
    add 'privacy-policy', :changefreq => 'monthly', :priority => 0.7
    add 'contact', :changefreq => 'monthly', :priority => 0.7
    add 'api', :changefreq => 'monthly', :priority => 0.7

    Server.find_each do |server|
      add '/server/' + server.id.to_s, lastmod: server.updated_at
    end

  end

  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end
end
