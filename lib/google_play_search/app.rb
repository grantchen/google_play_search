require 'nokogiri'
require File.expand_path(File.dirname(__FILE__) + '/review')

module GooglePlaySearch
  class App
    attr_accessor :id, :name, :url, :developer, :category, :logo_url,
                  :short_description, :rating, :reviews, :price,
                  :version, :installs, :last_updated, :size,
                  :requires_android, :content_rating, :developer_website,
                  :developer_email, :developer_address, :screenshots,
                  :long_description

    def get_all_details()
      html = HTTPClient.new.get(self.url).body
      google_play_html = Nokogiri::HTML(html)

      self.version = get_version(google_play_html)
      self.last_updated = get_last_updated(google_play_html)
      self.installs = get_installs(google_play_html)
      self.size = get_size(google_play_html)
      self.requires_android = get_requires_android(google_play_html)
      self.content_rating = get_content_rating(google_play_html)
      self.category = get_category(google_play_html)
      self.developer_website = get_developer_website(google_play_html)
      self.developer_email = get_developer_email(google_play_html)
      self.developer_address = get_developer_address(google_play_html)
      self.reviews = get_reviews(google_play_html)
      self.screenshots = get_screenshots(google_play_html)
      self.long_description = get_long_description(google_play_html)
      self
    rescue
      self
    end

    private

    def get_version(google_play_html)
      version = google_play_html.search("div[itemprop='softwareVersion']").first
      version.content.strip if version
    end

    def get_last_updated(google_play_html)
      last_updated = google_play_html.search("div[itemprop='datePublished']").first
      last_updated.content.strip if last_updated
    end

    def get_installs(google_play_html)
      installs = google_play_html.search("div[itemprop='numDownloads']").first
      installs.content.strip if installs
    end

    def get_size(google_play_html)
      size = google_play_html.search("div[itemprop='fileSize']").first
      size.content.strip if size
    end

    def get_requires_android(google_play_html)
      requires_android = google_play_html.search("div[itemprop='operatingSystems']").first
      requires_android.content.strip if requires_android
    end

    def get_content_rating(google_play_html)
      content_rating = google_play_html.search("div[itemprop='contentRating']").first
      content_rating.content.strip if content_rating
    end

    def get_category(google_play_html)
      category = google_play_html.search("span[itemprop='genre']").first
      category.content.strip if category
    end

    def get_developer_website(google_play_html)
      url = google_play_html.search("a[class='dev-link']").first['href'].strip.gsub("https://www.google.com/url?q=", "")
      url[0..(url.index("&") - 1)] if url.index("&")
    end

    def get_developer_email(google_play_html)
      google_play_html.search("a[class='dev-link']").each do |ele|
        return ele.content.strip.gsub("Email ", "") if ele.content.strip.index("Email")
      end
    end

    def get_developer_address(google_play_html)
      address = google_play_html.search("div[class='content physical-address']").first
      address.content.strip if address
    end

    def get_long_description(google_play_html)
      long_description = google_play_html.search("div[class='id-app-orig-desc']").first
      long_description.content.strip if long_description
    end

    def get_reviews(google_play_html)
      reviews = []
      google_play_html.search("div[class='single-review']").each do |ele|
        review = GooglePlaySearch::Review.new()
        review.author_name = ele.search("span[class='author-name']").first.content.strip
        review.author_avatar = ele.search("img[class='author-image']").first['src'].strip
        review.review_title = ele.search("span[class='review-title']").first.content.strip
        review.review_content = ele.search("div[class='review-body']").children[2].content.strip
        review.star_rating = ele.search("div[class='tiny-star star-rating-non-editable-container']").first['aria-label'].scan(/\d/).first.to_i
        reviews << review
      end
      reviews
    end

    def get_screenshots(google_play_html)
      screenshots = []
      google_play_html.search("div[class='screenshot-align-inner'] img").each do |ele|
        screenshots << ele['src'].strip
      end
      screenshots
    end

  end
end
