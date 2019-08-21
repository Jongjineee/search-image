require 'rails_helper'

describe ShutterstockService do
  describe '#call' do
    context '검색어를 입력했을 때' do

      it '검색 결과가 있으면 검색 결과를 반환한다' do
        result = ShutterstockService.call('soccer', 1)
        expect(result[:thumbs]).not_to be_nil
      end

      it '검색 결과가 없으면 빈 array를 반환한다' do
        result = ShutterstockService.call('asc', 1)
        expect(result[:thumbs]).to be_empty
      end
    end
  end
end