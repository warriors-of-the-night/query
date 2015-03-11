module Query
  module Result
    class QihuMobile
      include Query::Result
      def seo_ranks
      	@page.search("//div[@id='main']/div/div/div/a").map.with_index do |item,index|
          title = item.search('h3').first || item
          {
            :rank => index + 1,
            :href => item['href'],
            :text => title.text.gsub(/　|\n|\s/,""),
            :host => Addressable::URI.parse(item['href']).host
          }
        end
      end
    end
  end
end
