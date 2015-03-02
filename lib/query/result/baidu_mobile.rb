module Query
    module Result
        class BaiduMobile
            include Query::Result

            def seo_ranks
                s_res =  @page.at("//div[@id='results']")
                @seo_ranks ||= s_res.css("div.result").map.with_index do |div,index|
                    parse_seo(div).merge({:rank => index + 1})
                end
            end

            def ads_top
                @ads_top ||= @page.search("//*[@class='result']/preceding-sibling::div[not (contains(@class,'result'))]/div/div[@style='display:block !important']").map.with_index do |div,index|
                    parse_ad(div).merge({:rank => index + 1})
                end
            end

            def ads_bottom
                selt = "//*[@class='result']/following-sibling::div[not (contains(@class,'result'))]/div/div[@style='display:block !important']"
                @ads_bottom ||= @page.search(selt).map.with_index do |div,index|
                    parse_ad(div).merge({:rank => index + 1})
                end
            end

            #酒店预订 酒店英文 酒店团购 酒店管理 酒店招聘 快捷酒店 如家快捷酒店 五星级酒店
            def related_keywords
                @related_keywords ||= @page.search("div[@id='relativewords']/div[@class='rw-list']/a").map { |a| a.text }
            end

            def ads_right
                []
            end

            def next_url
               
            end

            def count

            end

            def html
              @page
            end

            private 
            def parse_ad(div)
                title_link = div.search('a').first
                url = div.search("link")
                if url.empty?
                    url = div.at("./div/div/div/*[contains(text(),'.com')]")
                    if not url
                        url = title_link['href']
                    else
                        url = "http://#{url.text.strip}"
                    end
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
            end

            def parse_seo(div)
                title_link = div.search('a').first
                href = title_link['href']
                href = href.include?('m.baidu.com') ? href : "http://m.baidu.com" + href
                if div['class']=='result'
                    host = div.search("*[@class='site']").first
                    host = host.text if host
                    title, is_vr = title_link.xpath("./text() | ./em").text, false
                elsif div['srcid'] and div['tpl']
                    url = JSON.parse(div['data-log'].gsub("'",'"'))['mu']
                    if url == ''
                        host = 'm.baidu.com'
                    else
                        host = Addressable::URI.parse(URI.encode(url)).host
                    end
                    title, is_vr = title_link.text, true

                elsif div['srcid'] == 'map'
                    host = 'map.baidu.com'
                    title, is_vr = title_link.text, true
                else
                    host = redirect(href)
                    title, is_vr = title_link.text, true
                end
                {   
                    :is_vr => is_vr,
                    :text  => title.gsub(/\n|\s/,''),
                    :href  => href,
                    :host  => host || redirect(href)
                }
            end
 
            def redirect(href,limit = 10) 
                raise ArgumentError, 'Too many HTTP redirects' if limit == 0
                response = Net::HTTP.get_response(URI(href))
                case response
                  when Net::HTTPSuccess then
                    return URI(href).host
                  when Net::HTTPRedirection then
                    location = response['location']
                    redirect(location, limit-1)
                  else
                    return nil
                end
            end 
        end
    end
end