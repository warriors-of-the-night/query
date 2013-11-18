module Query
	module Result
		class SogouMobile < Base
			def ads_top
				result = []
				@page.xpath("//div[@class='_ad_ VR_box']").each_with_index do |div,index|
					rank = index+1
					title = div.css('div a').text
					href = div.css('div a')[0]['href']
					host = div.css('div div span.site')[0].text.match(/[\w\.]+/)[0].downcase
					domain = host.sub('www.','')
					result << {:rank=>rank,:title=>title,:href=>href,:host=>host,:domain=>domain}
				end
				result
			end
		end
	end
end
