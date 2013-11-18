module Query
	module Result
		class Sogou < Base
			def ads_top
				result = []
				@page.css('div#promotion_adv_container ol li').each_with_index do |li,index|
					rank = index+1
					title = li.css('h3 a').text
					href = li.css('h3 a')[0]['href']
					host = li.css('cite')[0].text.match(/[\w\.]+/)[0].downcase
					domain = host.sub('www.','')
					result << {:rank=>rank,:title=>title,:href=>href,:host=>host,:domain=>domain}
				end
				result
			end
			def ads_right
				result = []
				@page.css('div#right div#bdfs0').each_with_index do |div,index|
					rank = index+1
					title = div.css('h3 a').text
					href = div.css('h3 a')[0]['href']
					host = div.css('div.fb a cite').text.match(/[\w\.]+/)[0].downcase
					domain = host.sub('www.','')
					result << {:rank=>rank,:title=>title,:href=>href,:host=>host,:domain=>domain}
				end
				result
			end
		end
	end
end