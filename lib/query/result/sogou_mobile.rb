require 'cgi'
module Query
	module Result
		class SogouMobile
			include Query::Result
			def ads_top
				@page.search("//div[@class='results']/div[@class='ec_ad_results'][1]/div[@class='ad_result']").map.with_index do |ad_div,index|
					parse_ad(ad_div).merge({:rank => (@pagenumber-1)*10 + index + 1})
				end
			end

			def ads_right
				[]
			end

			def ads_bottom
				@page.search("//div[@class='results']/div[@class='ec_ad_results'][2]/div[@class='ad_result']").map.with_index do |ad_div,index|
					parse_ad(ad_div).merge({:rank => (@pagenumber-1)*10 + index + 1})
				end
			end

			def seo_ranks
				@seo_rank ||= @page.search("//div[@class='results']/div[@class='result' or @class='vrResult']").map.with_index do |seo_div,index|
				  parse_seo_ranks(seo_div).merge({:rank => (@pagenumber-1)*10 + index + 1})
				end
			end

			def next_url
				"#{@baseuri.to_s}&p=#{@pagenumber+1}"
			end
			
      def related_keywords
        @related_keywords ||= @page.search("div[@class='hint']/ul/li/a").map{|relwd| relwd.text.gsub(/ |\n|\t/,"")}
      end
      
      def count
      end
      
      def html
      	@page.to_html
      end

      private
      def parse_ad(ad_div)
      	site = ad_div.search(".//span[@class='exp_tip']/preceding-sibling::span")[0] || ad_div.search(".//div[@class='bd_citeurl']/text()")[0]
				{
					:text => ad_div.search('h3')[0].text.gsub(/ |\n|\t/,""),
					:href => ad_div.search('a')[0]['href'],
					:host => site.text.strip.downcase
				}
      end
      
      def parse_seo_ranks(seo_div)
      	begin
      	a    = seo_div.search(".//a[contains(@href,'url=')]")[0]
			  href = URI.decode(CGI.parse(URI(URI.encode(a['href'])).query)['url'][0])
			  if href==""
			  	href = seo_div.search(".//div[@class='citeurl']/text()")[0].text.gsub(/ |-/,"")
			  	href = "http://#{href}"
			  end
			  if seo_div['class']=='result'
			  	is_vr, title = false, a.search("./text()|./em|./span")
			  else
			    seo_div.css('script').remove    # remove all script tags
			  	title = seo_div.search('.//h3')[0] || a.search("./text()|./span|./em")
			    is_vr = true
			  end
					{
						:text  => title.text.gsub(/ |\n|\t/,""),
						:href  => href,
						:host  => URI(URI.encode(href)).host,
						:is_vr => is_vr
					}
				rescue Exception => e
          warn "Error in parse_seo method : " + e.message
          {}
        end
      end
      
		end
	end
end
