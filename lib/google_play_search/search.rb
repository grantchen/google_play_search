require "rubygems"
require "nokogiri"
require "cgi"
require "httpclient"
require File.expand_path(File.dirname(__FILE__) + "/app_parser")

module GooglePlaySearch
  class Search
    attr_accessor :current_page, :keyword

    $GOOGLE_PLAY_STORE_BASE_URL = "https://play.google.com"

    GOOGLE_PLAY_BASE_SEARCH_URL = $GOOGLE_PLAY_STORE_BASE_URL + "/store/search"

    DEFAULT_SEARCH_CONDITION = { :language => "en",
                                 :category => "apps",
                                 :price => "0",
                                 :rating => "0" }

    def initialize(search_condition = DEFAULT_SEARCH_CONDITION)
      @search_condition = DEFAULT_SEARCH_CONDITION.merge(search_condition)
      @next_page_token = nil
      @current_page = 1
    end

    def search(keyword, options = {})
      @keyword = keyword
      page = HTTPClient.new.get(GOOGLE_PLAY_BASE_SEARCH_URL, query_params).body
      AppParser.new(page).parse
    end

    def next_page()
      @current_page += 1
      search @keyword
    end

    private

    def query_params
      params = {
        "q" => @keyword,
        "c" => @search_condition[:category],
        "hl" => @search_condition[:language],
        "price" => @search_condition[:price],
        "rating" => @search_condition[:rating],
        "start" => 0,
        "num" => 0,
      }
      if @next_page_token
        params["pagTok"] = @next_page_token
      end
      params
    end

    def get_next_page_token(response_body)
      if response_body.match(/(GAEi+.+:S:.{11})\\42/)
        @next_page_token = $~[1][-22..-1]
      end
    end
  end
end
