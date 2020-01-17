require File.expand_path(File.dirname(__FILE__) + "/app")
require File.expand_path(File.dirname(__FILE__) + "/utils")
require "json"

module GooglePlaySearch
  class AppParser
    include GooglePlaySearch::Utils

    SEARCH_APP_URL_END_SUFF = "&feature=search_result"

    def initialize(content)
      @content = content
    end

    def parse
      app_search_result_list = []
      content = @content.match(
        />AF_initDataCallback\({key: 'ds:3'.*{return(?<data>[\s\S]*?)}}\)\;<\/script/
      )[:data]
      data = JSON.parse(content)
      data[0][1][0][0][0].each do |app|
        app_search_result_list << create_app(app)
      end
      app_search_result_list
    end

    private

    def create_app(app_json)
      app = App.new
      app.url = "https://play.google.com" + app_json[9][4][2]
      app.id = app_json[12][0]
      app.name = app_json[2]
      app.price = app_json[7][0][3][2][1][0][2] if app_json[7].size > 0 && app_json[7][0][3]
      app.developer = app_json[4][0][0][0]
      app.logo_url = app_json[1][1][0][3][2]
      app.short_description = app_json[4][1][1][1][1]
      app.rating = app_json[6][0][2][1][0] if app_json[6].size > 0
      return app
    end
  end
end
