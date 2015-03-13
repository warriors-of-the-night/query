module Query
  module Result
    class BaiduMobile
      include Query::Result

      def seo_ranks
        s_res =  @page.at("//div[@id='results']")
        @seo_ranks ||= s_res.css("div.result").map.with_index do |seo_div,index|
          parse_seo(seo_div).merge({:rank => (index + 1) + (@pagenumber -1) * 10})
        end
      end

      def ads_top
        selector = "//*[@class='result']/preceding-sibling::div[not (contains(@class,'result'))]/div/div/a[not (contains(@href,'http://baozhang.baidu.com/guarantee'))]/.."
        @ads_top ||= @page.search(selector).map.with_index do |ad_div,index|
          parse_ad(ad_div).merge({:rank => (index + 1) + (@pagenumber -1) * 10})
        end
      end

      def ads_bottom
        selector = "//*[@class='result']/following-sibling::div[not (contains(@class,'result'))]/div/div/a[not (contains(@href,'http://baozhang.baidu.com/guarantee'))]/.."
        @ads_bottom ||= @page.search(selector).map.with_index do |ad_div,index|
          parse_ad(ad_div).merge({:rank => (index + 1) + (@pagenumber -1) * 10})
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
      def parse_ad(ad_div)
        begin
          title_link = ad_div.search('a')[0]
          url = ad_div.search('link')
          if url.empty?
            url = ad_div.search(".//span[contains(text(),'.com')]")[0]
            url = url.nil? ? "http://m.baidu.com" : "http://#{url.text.strip}"
            title = title_link.text
          else
            url = url[0]['href']
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

      def parse_seo(seo_div)
        begin
          title_link = seo_div.search('a')[0]
          href = title_link['href']
          href = href[/m.baidu.com/] ? href : "http://m.baidu.com#{href}"
          if seo_div['class']=='result'
            host, is_vr = seo_div.search(".//*[@class='site']")[0], false
            host = host.nil? ? find_host(seo_div) : host.text.split[0] 
          elsif seo_div['srcid']=='map'
            is_vr, host = true, 'map.baidu.com'          
          elsif seo_div['tpl'] and seo_div['data-log']
            url = JSON.parse(seo_div['data-log'].gsub("'",'"'))['mu']
            if url==''
            	host = find_host(seo_div)
            else
              host = Addressable::URI.parse(URI.encode(url)).host
            end
            is_vr = true
          else 
          	is_vr, host = true, find_host(seo_div)
          end
          #is_vr = (is_vr.nil? and !host[/baidu|nuomi/]) ? false : true     
          {   
            :is_vr => false || is_vr,
            :text  => title_link.text.gsub(/\n|\s/,'')[0..30],
            :href  => href,
            :host  => host
          }
        rescue Exception => e
          warn "Error in parse_seo method : " + e.message
          {}
        end
      end
      
			def find_host(node)
				host = node.search(".//*[name()!='style' and (contains(text(),'.cn') or contains(text(),'com'))]")[0]
				host.nil? ? 'm.baidu.com' : host.text.split[0]
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
