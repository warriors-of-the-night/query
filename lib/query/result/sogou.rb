module Query
	module Result
		class Sogou
      include Query::Result
			def ads_top
        return [] if sponsored_divs.empty?
        sponsored_divs.first.search("li").map.with_index do|li,index|
					{
            :rank => index + 1,
            :text => li.css('h3 a').text,
            :href => li.css('h3 a')[0]['href'],
            :host => Addressable::URI.parse(li.css('cite')[0].text).host
          }
				end
			end

			def ads_right
				@page.css('div#right div#bdfs0').map.with_index do |div,index|
          {
            :rank => index + 1,
            :text => div.css('h3 a').text,
            :href => div.css('h3 a')[0]['href'],
            :host => Addressable::URI.parse(div.css('div.fb a cite').text).host
          }
				end
			end

      def ads_bottom
        return [] if sponsored_divs.size < 2
      end

      def seo_ranks
        # @seo_ranks ||= @page.search("div[@class='result']/div/h3").map do |h3|
        @page.search("//div[@class='results']/div/h3").map.with_index do |h3,index|
          {
            :text => h3.search('a').first.text,
            :href => h3.search('a').first['href'],
            :host => Addressable::URI.parse(h3.search('a').first['href']).host,
            :rank => index + 1
          }
        end
      end

      def count
        ["//div[@class='zhanzhang']//em", "//span[@id='scd_num']"].each do |xpath|
          if counter_block = @page.search(xpath).first
            return counter_block.text.gsub(/\D/,'').to_i
          end
        end
      end

      def related_keywords
        @related_keywords ||= @page.search("table[@id='hint_container']/td").map{|td|td.first.text}
      end

      def next_url
        next_btn = @page.search("//a[text()='下一页>']")
        return false if next_btn.empty?
        next_btn.first['href']
      end

      def has_result?
        @page.search("div[@class='no-result']").empty?
      end

			# def rank(host)
   #      raise "unknown host object type:#{host}" unless host.class == Regexp or host.class == String

	  #     result = {}

   #      #顶部广告排名
   #      ranking_ads_top = 0
   #      ads_top.each do |line|
   #        ranking_ads_top += 1
   #        if host.class == Regexp and line[:host] =~ host
   #          result[:rank_top] = ranking_ads_top
   #          break
   #        elsif host.class == String and line[:host] == host
   #          result[:rank_top] = ranking_ads_top
   #          break
   #        end
   #      end

   #      #右侧广告排名
   #      ranking_ads_right = 0
   #      ads_right.each do |line|
   #        ranking_ads_right += 1
   #        if host.class == Regexp and line[:host] =~ host
   #          result[:rank_right] = ranking_ads_right
   #          break
   #        elsif host.class == String and line[:host] == host
   #          result[:rank_right] = ranking_ads_right
   #          break
   #        end
   #      end

   #      result
			# end
      private
      def sponsored_divs
        @page.search("div[@class='sponsored']")
      end
		end
	end
end