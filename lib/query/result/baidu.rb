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

      def ads_top
        @page.search("//div[@id='content_left']/*[not(contains(@class, 'result') or contains(@class, 'leftBlock') or name()='br') and position()<=7]").map.with_index do |div, index|
          parse_ad(div).merge(:rank => index + 1)
        end
      end

      def ads_bottom
        @page.search("//div[@id='content_left']/*[not(contains(@class, 'result') or contains(@class, 'leftBlock') or name()='br') and position()>=8]").map.with_index do |div, index|
          parse_ad(div).merge(:rank => index + 1)
        end
      end

      def ads_right
        @page.search("//div[@id='ec_im_container']/div[position()>1]").map.with_index do |div,index|
          parse_ad(div).merge(:rank => index + 1)
        end
      end

      def count
        node = @page.search("//div[@class='nums']") + @page.search("//span[@class='nums']")
        @count ||= node.map{|num|num.content.gsub(/\D/,'').to_i unless num.nil?}.first
        @count
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
        title = %w(div[1]/h3/a tbody/tr[2]/td/a[1] a[1]).inject(nil){|ans, xpath| ans || div.xpath(xpath).first}
        url   = %w(div[3]/span tbody/tr[2]/td/a[2] a[3]/font[last()]).inject(nil){|ans, xpath| ans || div.xpath(xpath).first}
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
