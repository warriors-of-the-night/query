module Query
  module Result
    class Baidu
      include Query::Result
      def seo_ranks
        return @ranks unless @ranks.nil?
        @page.search("//div[@id='content_left']/*[contains(@class, 'result')]").map.with_index do |div,index|
          parse_seo(div).merge({:rank => index + 1})
        end
      end

      def ads_top
        @page.search("//div[@id='content_left']/*[not(contains(@class, 'result') or contains(@class, 'leftBlock') or name()='br' or @id='rs_top_new' or @id='super_se_tip') and position()<=7]").map.with_index do |div, index|
          parse_ad(div).merge(:rank => index + 1)
        end
      end

      def ads_bottom
        @page.search("//div[@id='content_left']/*[not(contains(@class, 'result') or contains(@class, 'leftBlock') or name()='br' or @id='rs_top_new' or @id='super_se_tip') and position()>=11]").map.with_index do |div, index|
          parse_ad(div).merge(:rank => index + 1)
        end
      end

      def ads_right
        @page.search("//div[@id='ec_im_container']/div[contains(@class, 'EC_idea')]").map.with_index do |div,index|
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
          :text => title.text.strip,
          :href => title['href'].to_s.strip,
          :host => Addressable::URI.parse(URI.encode(url)).host
        }
      end

      def parse_seo(div)
        title = %w(div[1]/h3/a h3/a).inject(nil){|ans, xpath| ans || div.xpath(xpath).first}
        url   = %w(span[@class="g"] span[@class="c-showurl"]/span[@class="c-showurl"] span[@class="c-showurl"] span[@class="op_wiseapp_showurl"] div[@class="op_zhidao_showurl"]).inject(nil){|ans, xpath| ans || div.search(xpath).first}
        url = url.nil? ? 'www.baidu.com' : url.text.sub(/\d{4}-\d{1,2}-\d{1,2}/,'').strip
        url = "http://" + url

        {
          :is_vr=> div['class'] == 'result-op c-container',
          :text => title.text.strip,
          :href => title['href'].to_s.strip,
          :host => Addressable::URI.parse(URI.encode(url)).host
        }
      end
    end
  end
end
