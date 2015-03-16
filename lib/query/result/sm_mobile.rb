module Query
  module Result
    class SMobile
      include Query::Result

      def seo_ranks
        @seo_ranks ||= @page.search("//div[@id='results']/div[@class!='ali_row result card']").map.with_index do |seo_div,index|
          parse_seo(seo_div).merge({:rank => (index + 1) + (@pagenumber -1) * 10})
        end
      end

      def ads_top
        selector = "//div[@id='results']/div[@class='result card'][1]/preceding-sibling::div[@class='ali_row result card']"
        @ads_top ||= @page.search(selector).map.with_index do |ad_div,index|
          parse_ad(ad_div).merge({:rank => (index + 1) + (@pagenumber -1) * 10})
        end
      end

      def ads_bottom
        selector = "//div[@id='results']/div[@class='result card'][1]/following-sibling::div[@class='ali_row result card']"
        @ads_bottom ||= @page.search(selector).map.with_index do |ad_div,index|
          parse_ad(ad_div).merge({:rank => (index + 1) + (@pagenumber -1) * 10})
        end
      end

      #relative words
      def related_keywords
        @related_keywords ||= @page.search("//div[@class='rel-keywords card']/ul/li/a").map { |a| a.text }
      end

      def html
        @page.to_html
      end

      def ads_right
        []
      end

      def next_url
        	"#{@baseuri.to_s}&page=#{@pagenumber+1}"
      end

      def count

      end

    private 
      def parse_ad(ad_div)
        begin
          title_link = ad_div.at_css('a') 
          title = title_link.search('./text()|./em|./span')
          url = ad_div.search('.//div[@class="host"]/text()').text
          url = "http://#{url}" if !url[/http:/]   
           {
              :text => title.text.gsub(/\n|\s/,''),
              :href => title_link['href'],
              :host => URI(URI.encode(url.gsub(/ |\n|\t|\s/,""))).host
           }
        rescue Exception => e
         warn "Error in parse_ads method : " + e.message
         {}
        end
      end

      def parse_seo(seo_div)	
        begin
          title_link = seo_div.at('.//a[contains(@href,"http://")]')
          href = title_link['href']
          if seo_div['class']=="result card"
            is_vr = false
            url   = seo_div.search('.//div[@class="host"]/span/text()[matches(.,"\w+.\w+")]', XpathFunctions.new)[0] || href
          else
            is_vr, url = true, href
          end
          url = "http://#{url}" if !url[/http:/]   
          {   
            :is_vr => is_vr,
            :text  => title_link.text.gsub(/\n|\s/,'')[0..30],
            :href  => href,
            :host  => URI(URI.encode(url.gsub(/ |\n|\t|\s/,""))).host # remove &nbsp and whitespace
          }
        rescue Exception => e
          warn "Error in parse_seo method : " + e.message
          {}
        end
      end
      
      class XpathFunctions 
      	def matches node_set, regex
       		node_set.find_all {|node| node.to_s[/#{regex}/] }
      	end
      end
    end
  end
end
