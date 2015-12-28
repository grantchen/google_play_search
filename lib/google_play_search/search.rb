require 'rubygems'
require 'nokogiri'
require 'cgi'
require File.expand_path(File.dirname(__FILE__) + '/app_parser')

module GooglePlaySearch
  class Search
    attr_accessor :current_page, :keyword

    $GOOGLE_PLAY_STORE_BASE_URL = "https://play.google.com"

    GOOGLE_PLAY_BASE_SEARCH_URL = $GOOGLE_PLAY_STORE_BASE_URL + "/store/search?q="

    DEFAULT_SEARCH_CONDITION = {:language => "en",
      :category => "apps",
      #:per_page_num => 20,
      :price => "0",
      #:safe_search => "0",
      :rating => "0"}

    def initialize(search_condition = DEFAULT_SEARCH_CONDITION)
      @search_condition = DEFAULT_SEARCH_CONDITION.merge(search_condition)
      @next_page_token = nil
      @current_page = 1
    end

    def search(keyword, options={})
      @keyword = keyword
      page = HTTPClient.new.get(init_query_url).body
      get_next_page_token(page)
      AppParser.new(page).parse
    end

    def next_page()
      @current_page += 1
      search @keyword
    end

    private
    def init_query_url
      query_url = ""
      query_url << GOOGLE_PLAY_BASE_SEARCH_URL
      query_url << CGI.escape(@keyword) << "&"
      query_url << "c=" << @search_condition[:category] << "&"
      query_url << "hl=" << @search_condition[:language] << "&"
      query_url << "price=" << @search_condition[:price] << "&"
      query_url << "rating=" << @search_condition[:rating] << "&"
      #query_url << "safe=" << @search_condition[:safe_search] << "&"
      #query_url << "sort=" << @search_condition[:sort_by] << "&"
      query_url << "start=0&num=0"
      if @next_page_token
        query_url << "&pagTok=#{@next_page_token}"
      end
      query_url
    end

    def get_next_page_token(response_body)
      if response_body.match(/(GAEi+.+:S:.{11})\\42/)
        @next_page_token = $~[1][-22..-1]
      end
    end
  end
end
