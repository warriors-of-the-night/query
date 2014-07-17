module Query
  module Result
    class BaiduMobileApi
      include Query::Result

      def ads_top
        @page.xpath("//div[@id='results']/div[@class='ec_wise_ad']//div[contains(@class,'ec_resitem ec_wise_pp')]").map.with_index do |div,index|
          parse_ad(div).merge({rank: index + 1})
        end

        # @ads_top ||= @page.search("//div[@id='results']/div[@class='ec_wise_ad']/div/div").map.with_index do |div,index|
        #   parse_ad(div).merge({rank: index + 1})
        # end
      end

      def ads_bottom
        @page.xpath("//div[@id='results']/div[@class='ec_wise_ad']//div[@class='ec_resitem ec_wise_im']").map.with_index do |div,index|
          parse_ad(div).merge({rank: index + 1})
        end
        # @ads_bottom ||= @page.search("//*[@class='result']/following-sibling::div[@class='ec_wise_ad']/div/div").map.with_index do |div,index|
        #   parse_ad(div).merge({rank: index + 1})
        # end
      end

      private
      def parse_ad(div)
        host = div.search("span[@class='ec_site']").first
        if host
          host = host.text
          {
            text: div.search('a/text()').text.strip,
            href: "http://#{host}",
            host: host
          }
        else
          {}
        end
      end
    end
  end
end
