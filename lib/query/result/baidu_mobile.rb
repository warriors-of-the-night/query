module Query
  module Result
    class BaiduMobile
      include Query::Result

      def seo_ranks
        s_res =  @page.at("//div[@id='results']")
        @seo_ranks ||= s_res.css("div.result").map.with_index do |div,index|
          parse_seo(div).merge({:rank => (index + 1) + (@pagenumber -1) * 10})
        end
      end

      def ads_top
        selector = "//*[@class='result']/preceding-sibling::div[not (contains(@class,'result'))]/div/div/a[not (contains(@href,'http://baozhang.baidu.com/guarantee'))]/.."
        @ads_top ||= @page.search(selector).map.with_index do |div,index|
          parse_ad(div).merge({:rank => (index + 1) + (@pagenumber -1) * 10})
        end
      end

      def ads_bottom
        selector = "//*[@class='result']/following-sibling::div[not (contains(@class,'result'))]/div/div/a[not (contains(@href,'http://baozhang.baidu.com/guarantee'))]/.."
        @ads_bottom ||= @page.search(selector).map.with_index do |div,index|
          parse_ad(div).merge({:rank => (index + 1) + (@pagenumber -1) * 10})
        end
      end

      #酒店预订 酒店英文 酒店团购 酒店管理 酒店招聘 快捷酒店 如家快捷酒店 五星级酒店
      def related_keywords
        @related_keywords ||= @page.search("//div[@id='relativewords']/div[@class='rw-list']/a").map { |a| a.text }
      end

      def html
        @page.to_html
      end

      def ads_right
        []
      end

      def next_url
      	next_bn = @page.search("//div[@id='pagenav']/a").first
        url = next_bn.nil? ? "/s?#{@baseuri.query}&pn=#{@pagenumber*10}" : next_bn['href']
        url
      end

      def count

      end

    private 
      def parse_ad(div)
        begin
          title_link = div.search('a').first
          url = div.search('link')
          if url.empty?
            url = div.search(".//span[contains(text(),'.com')]").first
            url = url.nil? ? "http://m.baidu.com" : "http://#{url.text.strip}"
            title = title_link.text
          else
            url = url.first['href']
            title = title_link.xpath("./text() | ./em").text
          end
           {
              :text => title.gsub(/\n|\s/,''),
              :href => title_link['href'],
              :host => Addressable::URI.parse(URI.encode(url)).host
           }
        rescue Exception => e
         warn "Error in parse_seo method : " + e.message
         {}
        end
      end

      def parse_seo(div)
        begin
          title_link = div.search('a').first
          href = title_link['href']
          href = href.include?('m.baidu.com') ? href : "http://m.baidu.com#{href}"
          if div['srcid'] == 'map'
            host, is_vr = 'map.baidu.com', true
          elsif div['class']=='result'
            host = div.search(".//*[@class='site']").first
            host = host.text if host
          elsif div['tpl'] and div['data-log']
            url = JSON.parse(div['data-log'].gsub("'",'"'))['mu']
            host  = url=='' ? "m.baidu.com" : Addressable::URI.parse(URI.encode(url)).host
            is_vr = true
          end
          host = host || "m.baidu.com"
          is_vr = (is_vr.nil? and !host[/baidu|nuomi/]) ? false : true     
          {   
            :is_vr => is_vr,
            :text  => title_link.text.gsub(/\n|\s/,'')[0..30],
            :href  => href,
            :host  => host
          }
        rescue Exception => e
          warn "Error in parse_seo method : " + e.message
          {}
        end
      end

      def redirect(url,limit = 10) 
        raise ArgumentError, 'Too many HTTP redirects' if limit == 0
        response = Net::HTTP.get_response(URI(url))
        case response
          when Net::HTTPSuccess then
            return URI(url).host
          when Net::HTTPRedirection then
            location = response['location']
            redirect(location, limit-1)
          else
            return "m.baidu.com"
        end
      end 
    end
  end
end
