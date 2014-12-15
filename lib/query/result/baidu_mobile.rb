module Query
    module Result
        class BaiduMobile
            include Query::Result

            def seo_ranks
                @seo_ranks ||= @page.search("//*[@class='result']|//*[@class='card-result wa-ue-card-result']|//*[@class='result card-result wma-card-box']").map.with_index do |div,index|
                    parse_seo(div).merge({:rank => index + 1})
                end
            end

            def ads_top
                @ads_top ||= @page.search("//*[@class='result']/preceding-sibling::div[@class='ec_wise_ad']/div").map.with_index do |div,index|
                    parse_ad(div).merge({:rank => index + 1})
                end
            end

            def ads_right
                []
            end

            def ads_bottom
                @ads_bottom ||= @page.search("//*[@class='result']/following-sibling::div[@class='ec_wise_ad']/div/div").map.with_index do |div,index|
                    parse_ad(div).merge({:rank => index + 1})
                end
            end

            #酒店预订 酒店英文 酒店团购 酒店管理 酒店招聘 快捷酒店 如家快捷酒店 五星级酒店
            def related_keywords
                @related_keywords ||= @page.search("div[@class='rw-list']/a").map{|a|a.text}
            end

            def next_url
               @next_url ||= @page.xpath('//a[contains(text(),"下一页")]').first['href']
            end

            def count

            end

            private
            def parse_ad(div)
                url = div.search("span[@class='ec_site']").first.text
                url = "http://#{url}"
                {
                    :text => div.search('a/text()').text.strip,
                    :href => div.search('a').first['href'],
                    :host => Addressable::URI.parse(URI.encode(url)).host
                }
            end

            def parse_seo(div)
                a = div.search('a').first
                if div['class'] == 'card-result wa-ue-card-result'
                    host = div.search("*[@class='wa-hotelgeneral-gray wa-hotelgeneral-info-sub-title']").text
                elsif div['class'] == 'result card-result wma-card-box' and div['srcid'] == 'map'
                    host = 'map.baidu.com'
                else
                    host = div.search("*[@class='site']").first.text
                end
                {
                    :text => a.text,
                    :href => a['href'],
                    :host => host
                }
            end
        end
    end
end