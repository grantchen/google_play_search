require File.expand_path(File.dirname(__FILE__) + '/app')

module GooglePlaySearch
	class AppParser
		SEARCH_APP_URL_END_SUFF = "&feature=search_result"

		def initialize(content)
		  @doc = Nokogiri::HTML(content)
		end
		def parse
		  app_search_result_list = []
		  @doc.css("li.search-results-item div.snippet").each do |app_content|
		      app = App.new
		      app.url = get_url app_content
		      app.id = app.url[app.url.index("?id=")+4..-1]
		      app.name = get_name app_content
		      app.developer = get_developer app_content
		      app.category = get_category app_content
		      app.logo_url = get_logo_url app_content
		      app.short_description = get_short_description app_content
		      app_search_result_list << app
		  end
		  app_search_result_list
		end

		private
		def get_url(app_content)
		  url = $GOOGLE_PLAY_STORE_BASE_URL + app_content.css("div.thumbnail-wrapper a").first['href']
		  if url.end_with?(SEARCH_APP_URL_END_SUFF)
		    url = url[0..-1* (SEARCH_APP_URL_END_SUFF.size + 1)]
		  end
		  url
		end

		def get_logo_url(app_content)
		  app_content.css("div.thumbnail-wrapper a.thumbnail img").first['src']
		end

		def get_name(app_content)
		  app_content.css("div.details a.title").first.content
		end

		def get_developer(app_content)
		  app_content.css("div.details div.attribution-category span.attribution a").first.content
		end

		def get_category(app_content)
		  app_content.css("div.details div.attribution-category span.category a").first.content
		end

		def get_short_description(app_content)
		  app_content.css("div.description").first.content
		end
	end
end
