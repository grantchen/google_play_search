module GooglePlaySearch::Utils
  def add_http_prefix(url)
    unless url.start_with?("http")
      return "https:" + url
    end
  end

  def get_image_url_from_style(url)
    if url.start_with?("background-image:url(")
      return url["background-image:url(".length..-2]
    end
  end
end
