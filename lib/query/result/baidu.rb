module Query
  module Result
    class Baidu
      include Query::Result
      def seo_ranks
        return @ranks unless @ranks.nil?
        @page.search("//*[@class='result']|//*[@class='result-op']|//*[@class='result-op c-container']").map.with_index do |table,index|
          parse_seo(table).merge({:rank => index + 1})
        end
      end

      def ads_top
        @page.search("//*[@class='result']/preceding-sibling::*[contains(@class,'EC_result')]").map.with_index do |div, index|
          parse_ad(div).merge(:rank => index + 1)
        end
      end

      def ads_bottom
        @page.search("//*[@class='result']/following-sibling::*[contains(@class,'EC_result')]").map.with_index do |div,index|
          parse_ad(div).merge(:rank => index + 1)
        end
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
        @page.search("//a[text()='下一页>']").first['href']
      end

      private
      def parse_ad(div)
        #@todo  should be :
        #title = div.xpath("*[contains(@class,'ec_title')]",MyFilter.new).first
        title = div.xpath("//*[contains(@class,'ec_title')]",MyFilter.new).first
        url = %w( span[@class='ec_url']  a[@class='EC_url'] ).map do |xpath|
          node = div.search(xpath).first
          node.text if node
        end.compact.first
        url = "http://" + url
        {
          :text => title.text,
          :href => title['href'],
          :host => Addressable::URI.parse(URI.encode(url)).host
        }
      end

      def parse_seo(table)
        url = %w( span[@class="g"]  span[@class="c-showurl"] div[@class="op_zhidao_showurl"]).map do |xpath|
          span = table.search(xpath).first
          span.text.sub(/\d{4}-\d{1,2}-\d{1,2}/,'').strip if span
        end.compact.first
        host = Addressable::URI.parse(URI.encode("http://#{url}")).host
        {
          :text => table.search("h3").first.text.strip,
          :href => table.search('a').first['href'].strip,
          :host => host
        }
      end
    end
  end
end
