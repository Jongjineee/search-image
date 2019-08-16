class IntrosController < ApplicationController
  def index
    flash[:error] = ''
    search_word = params[:search_word]
    page = params[:page]
    if search_word.present?
      results = ShutterstockService.call(search_word, page)
      @images = results[:thumbs]
      @pages = results[:pages]
    end
  rescue => e
    flash[:error] = e.message
  end
end
