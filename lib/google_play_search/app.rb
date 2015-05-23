require 'open-uri'
module GooglePlaySearch
  class App
    attr_accessor :id, :name, :url, :developer, :category, :logo_url,
                  :short_description, :rating, :reviews, :price,
                  :version, :installs, :last_updated, :size,
                  :requires_android, :content_rating

    def get_all_details()
      html = open(self.url).read()
      google_play_html = Nokogiri::HTML(html)

      self.version = get_version(google_play_html)
      self.last_updated = get_last_updated(google_play_html)
      self.installs = get_installs(google_play_html)
      self.size = get_size(google_play_html)
      self.requires_android = get_requires_android(google_play_html)
      self.content_rating = get_content_rating(google_play_html)
      self.category = get_category(google_play_html)
      self
    end

    private

    def get_version(google_play_html)
      google_play_html.search("div[itemprop='softwareVersion']").first.content.strip
    end

    def get_last_updated(google_play_html)
      google_play_html.search("div[itemprop='datePublished']").first.content.strip
    end

    def get_installs(google_play_html)
      google_play_html.search("div[itemprop='numDownloads']").first.content.strip
    end

    def get_size(google_play_html)
      google_play_html.search("div[itemprop='fileSize']").first.content.strip
    end

    def get_requires_android(google_play_html)
      google_play_html.search("div[itemprop='operatingSystems']").first.content.strip
    end

    def get_content_rating(google_play_html)
      google_play_html.search("div[itemprop='contentRating']").first.content.strip
    end

    def get_category(google_play_html)
      google_play_html.search("span[itemprop='genre']").first.content.strip
    end
  end
end
