require 'nokogiri'
require File.expand_path(File.dirname(__FILE__) + '/review')
require File.expand_path(File.dirname(__FILE__) + '/utils')

module GooglePlaySearch
  class App
    include GooglePlaySearch::Utils

    attr_accessor :id, :name, :url, :developer, :category, :logo_url,
                  :short_description, :rating, :ratings_count, :reviews, :price,
                  :count_5_star, :count_4_star, :count_3_star, :count_2_star, :count_1_star,
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
      self.long_description = get_long_description(google_play_html)

      self.ratings_count = get_ratings_count(google_play_html)
      self.count_5_star = get_star_count(5, google_play_html)
      self.count_4_star = get_star_count(4, google_play_html)
      self.count_3_star = get_star_count(3, google_play_html)
      self.count_2_star = get_star_count(2, google_play_html)
      self.count_1_star = get_star_count(1, google_play_html)

      self.reviews = get_reviews(google_play_html)
      self.screenshots = get_screenshots(google_play_html)
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
        return ele['href'].strip.gsub("mailto:", "") if ele['href'].strip.index("mailto:")
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
      google_play_html.search("div[class='featured-review']").each do |ele|
        review = GooglePlaySearch::Review.new()
        review.author_name = ele.search("span[class='author-name']").first.content.strip
        review.author_avatar = get_image_url_from_style(
                  ele.search("span[class='responsive-img author-image']").first['style'].strip)
        review.review_title = ele.search("span[class='review-title']").first.content.strip
        review.review_content = ele.search("div[class='review-text']").children[2].content.strip
        review.star_rating = ele.search("div[class='tiny-star star-rating-non-editable-container']").first['aria-label'].scan(/\d/).first.to_i
        reviews << review
      end
      reviews
    end

    def get_screenshots(google_play_html)
      screenshots = []
      google_play_html.search("div[class='screenshot-align-inner'] img").each do |ele|
        screenshots << add_http_prefix(ele['src'].strip)
      end
      screenshots
    end

    def get_ratings_count(google_play_html)
      ratings_count = google_play_html.search("span[class='reviews-num']").first
      ratings_count.content.strip if ratings_count
    end

    def get_star_count(num_stars, google_play_html)
      star_word = ['zero', 'one', 'two', 'three', 'four', 'five'][num_stars]

      stars_root = google_play_html.search("div[class='rating-bar-container #{star_word}']").first
      stars_count = stars_root.search("span[class='bar-number']").first if stars_root
      stars_count.content.strip if stars_count
    end
  end
end
