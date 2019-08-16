class ShutterstockService
  def initialize(search_word, page)
    @search_word = search_word
    @api_client = Rails.application.credentials.shutterstock[:consumer_key]
    @api_secret = Rails.application.credentials.shutterstock[:consumer_secret]
    @api_base_url = "api.shutterstock.com/v2/images/search?query="
    @page = page
    @images = RestClient.get(build_url)
  end

  def self.call(search_word, page)
    new(search_word, page).call
  end

  def call
    result = {'thumbs': create_thumbs, 'pages': create_page_count}
    return result
  end

  private

  def build_url
    URI.escape("https://#{@api_client}:#{@api_secret}@#{@api_base_url}#{@search_word}&page=#{@page}&per_page=100&language=ko")
  end

  def create_page_count
    total_images = JSON.parse(@images)["total_count"]
    pages_count = total_images/100
    return pages_count
  end

  def get_image_json
    images_json = JSON.parse(@images)['data']
    return images_json
  end

  def create_thumbs
    images_json = get_image_json
    thumbs = []
    images_json.each do |image|
      thumbs.push(image['assets']['preview']['url'])
    end
    return thumbs
  end
end