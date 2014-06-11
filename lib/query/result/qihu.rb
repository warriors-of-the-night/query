module Query
  module Result
    class Qihu
      include Query::Result
      def seo_ranks
        @page.search('//ul[@id="m-result"]/li//h3').map.with_index do |h3,index|
          a = h3.search('a').first
          {
            :rank => index + 1,
            :href => a['href'],
            :text => a.text.strip,
            :host => Addressable::URI.parse(a['href']).host
          }
        end
      end

      def ads_top
        @page.search("//ul[@id='djbox']/li").map.with_index do |li,index|
          a = li.search("a").first
          href = li.search("cite").first.text.downcase

          {
            :rank => index + 1,
            :text => a.text,
            :href => href,
            :host => Addressable::URI.parse(URI.encode(href)).host
          }
        end
      end

      def ads_bottom
        []
      end

      def ads_right
        @page.search("//ul[@id='rightbox']/li").map.with_index do |li,index|
          a = li.search('a').first
          href = li.search("cite").first.text.downcase
          host = Addressable::URI.parse(URI.encode(href)).host
          next if a.text.include?'想在360推广您的产品服务吗'
          {
            :rank => index + 1,
            :text => a.text,
            :href => href,
            :host => host
          }
        end.compact
      end

      def related_keywords
        []
      end

      def count
        @page.search('//span[@class="nums"]').first.text.gsub(/\D/,'').to_i
      end

      #下一页
      def next_url
        next_href = @page.xpath('//a[@id="snext"]').first['href']
      end
      #有结果
      def has_result?
        !@page.search('//div[@id="main"]/h3').text().include?'没有找到该URL'
      end
      #被封
      def blocked?
        @page.search('//ul[@id="m-result"]').first.nil? and @page.to_s.include?'您的请求暂时无法响应'
      end
      #被封的IP
      def blocked_ip
        (/(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})/.match @page.to_s).to_s
      end
    end
  end
end