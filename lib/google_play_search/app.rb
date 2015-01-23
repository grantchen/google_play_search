require 'open-uri'
module GooglePlaySearch
  class App
    attr_accessor :id, :name, :url, :developer, :category, :logo_url, :short_description, :rating, :reviews, :price, :version, :installs, :last_updated

    def get_all_details()
      html = open(self.url).read()
      @google_play_html = Nokogiri::HTML(html)

      self.version = get_version 
      self.last_updated = get_last_updated 
      self.installs = get_installs
      self
    end


  	private
  	def get_version()
      @google_play_html.search("div[itemprop='softwareVersion']").first.content.strip
    end

    def get_last_updated()
      @google_play_html.search("div[itemprop='datePublished']").first.content.strip
    end

    def get_installs()
      @google_play_html.search("div[itemprop='numDownloads']").first.content.strip
    end
  end
end