require 'uri'

class IntrosController < ApplicationController
  def index
    flash[:error] = ''
    search_word = params[:search_word]
    page = set_page
    if search_word.present?
      shutterstock_results = ShutterstockService.call(search_word, page)
      unsplash_results = UnsplashService.call(search_word, page)
      
      @images = shutterstock_results[:thumbs] + unsplash_results[:thumbs]
      pages = [*1..set_more_pages(shutterstock_results[:pages], unsplash_results[:pages])]
      @paginatable_array = Kaminari.paginate_array(pages).page(params[:page]).per(1)
    end
  rescue => e
    flash[:error] = e.message
  end

  private

  def set_page
    return params[:page] if params[:page]
    return 1
  end

  def set_more_pages(shutterstock_pages, unsplash_pages)
    return shutterstock_pages if shutterstock_pages > unsplash_pages
    return unsplash_pages
  end
end
