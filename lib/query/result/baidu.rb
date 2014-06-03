module Query
  module Result
    class Baidu
      include Query::Result
      def seo_ranks
        return @ranks unless @ranks.nil?
        @page.search("//*[@class='result']|//*[@class='result-op']|//*[@class='result-op c-container']|//*[@class='result c-container']").map.with_index do |table,index|
          parse_seo(table).merge({:rank => index + 1})
        end
      end

      # def ads_top
      #   @page.search("//*[@class='result']/preceding-sibling::*[contains(@class,'EC_result')]").map.with_index do |div, index|
      #     parse_ad(div).merge(:rank => index + 1)
      #   end
      # end

      def ads_left
        @page.xpath("//div[@id='content_left']//*[contains(@class,'EC_result')]",MyFilter.new).map.with_index do |div,index|
          parse_ad(div)#.merge(:rank => index + 1)
        end
      end

      def ads_top
        ads_left.uniq.map.with_index do |ad,index|
          ad.merge(:rank => index + 1)
        end
      end

      def ads_bottom
        # @page.search("//*[@class='result']/following-sibling::*[contains(@class,'EC_result')]").map.with_index do |div,index|
        #   parse_ad(div)#.merge(:rank => index + 1)
        # end
        ads_top
      end

      def ads_right
        @page.search("//div[@id='ec_im_container']/div[@id]").map.with_index do |div,index|
          a = div.search('a').first
          url = div.search("*[@class='EC_url']").first.text
          url = "http://#{url}"
          {
            :rank => index + 1,
            :text => a.text.strip,
            :href => a['href'].strip,
            :host => Addressable::URI.parse(URI.encode(url)).host
          }
        end
      end

      def count
        @count ||= @page.search("//span[@class='nums']").map{|num|num.content.gsub(/\D/,'').to_i unless num.nil?}.first
      end

      def related_keywords
        @related_keywords ||= @page.search("//div[@id=\"rs\"]//tr//a").map{|keyword| keyword.text}
      end

      def has_result?
        submit = @page.search('//a[text()="提交网址"]').first
        return false if submit and submit['href'].include?'sitesubmit'
        return true
      end

      def next_url
        next_btn = @page.search("//a[text()='下一页>']")
        return false if next_btn.empty?
        next_btn.first['href']
      end

      private
      def parse_ad(div)
        #@todo  should be :
        #title = div.xpath("*[contains(@class,'ec_title')]",MyFilter.new).first
        title = div.xpath(".//*[contains(@class,'ec_title')]",MyFilter.new).first
        url = div.xpath(".//*[contains(@class,'ec_url')]",MyFilter.new).first
        url = url.nil? ? 'www.baidu.com' : url.text
        url = "http://" + url
        {
          :text => title.text,
          :href => title['href'],
          :host => Addressable::URI.parse(URI.encode(url)).host
        }
      end

      def parse_seo(table)
        url = %w( span[@class="g"]  span[@class="c-showurl"] span[@class="op_wiseapp_showurl"] div[@class="op_zhidao_showurl"]).map do |xpath|
          span = table.search(xpath).first
          span.text.sub(/\d{4}-\d{1,2}-\d{1,2}/,'').strip if span
        end.compact.first
        if url and !url.empty?
          host = Addressable::URI.parse(URI.encode("http://#{url}")).host
        else
          host = nil
        end
        href = table.search('a').first['href']
        href = href.strip if href

        {
          :text => table.search("h3").first.text.strip,
          :href => href,
          :host => host
        }
      end
    end
  end
end
