class UnsplashService
  def initialize(search_word, page)
    @search_word = search_word
    @api_client = Rails.application.credentials.unsplash[:client_id]
    @api_secret = Rails.application.credentials.unsplash[:client_secret]
    @api_base_url = "api.unsplash.com/search/photos?"
    @page = page
    @images = RestClient.get(build_url)
  end

  def self.call(search_word, page)
    new(search_word, page).call
  end

  def call
    result = {'thumbs': create_thumbs, 'pages': create_total_pages_count}
    return result
  end

  private

  def build_url
    URI.escape("https://#{@api_base_url}client_id=#{@api_client}&page=#{@page}&per_page=20&query=#{@search_word}")
  end

  def create_total_pages_count
    total_images = JSON.parse(@images)["total"]
    total_pages_count = total_images/20
    return total_pages_count
  end

  def get_image_json
    images_json = JSON.parse(@images)['results']
    return images_json
  end

  def create_thumbs
    images_json = get_image_json
    thumbs = []
    images_json.each do |image|
      thumbs.push(image['urls']['small'])
    end
    return thumbs
  end
end