require 'cgi'
module Query
	module Result
		class SogouMobile
			include Query::Result
			def ads_top
				@page.search("//ul[@class='searchresult']/li[1]/preceding-sibling::div").map.with_index do |ad_div,index|
					parse_ad(ad_div).merge({:rank => index + 1})
				end
			end

			def ads_right
				[]
			end

			def ads_bottom
				@page.search("//ul[@class='searchresult']/li[last()]/following-sibling::div").map.with_index do |div,index|
					parse_ad(div).merge({:rank => index + 1})
				end
			end

			def seo_ranks
				@seo_rank ||= @page.search("//ul[@class='searchresult']/li/a").map.with_index do |a,index|
					href = URI.decode(CGI.parse(URI(URI.encode(a['href'])).query)['url'].first)
					{
						:rank => index + 1,
						:text => a.search('h3').text,
						:href => href,
						:host => URI(href).host
					}
				end
			end

			def next_url
				@page.search("//a[text()='下一页']").first['href']
			end

      def count
      end

      private
      def parse_ad(ad_div)
				{
					:text => ad_div.search('h3').first.text,
					:href => ad_div.search('a').first['href'],
					:host => Addressable::URI.parse("http://#{ad_div.search('span[@class="site"]').text}").host
				}
      end
		end
	end
end
