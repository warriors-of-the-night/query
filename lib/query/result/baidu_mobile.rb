module Query
    module Result
        class BaiduMobile
            include Query::Result
            #返回当前页所有查询结果
            def ranks
                #如果已经赋值说明解析过,不需要重新解析,直接返回结果
                return @ranks unless @ranks.nil?
                @ranks = Hash.new
                @page.xpath('//div[@class="result"]').each do |result|
                    href,text,host,is_mobile = '','','',false
                    a = result.search("a").first
                    is_mobile = true unless a.search("img").empty?
                    host = result.search('[@class="site"]').first
                    next if host.nil?
                    host = host.text
                    href = a['href']
                    text = a.text
                    id = href.scan(/&order=(\d+)&/)
                    if id.empty?
                        id = nil
                    else
                        id = id.first.first.to_i
                        # id = (@pagenumber-1)*10+id
                    end
=begin
                    result.children.each do |elem|
                        if elem.name == 'a'
                            href = elem['href']
                            id = elem.text.match(/^\d+/).to_s.to_i
                            text = elem.text.sub(/^\d+/,'')
                            text.sub!(/^\u00A0/,'')
                        elsif elem['class'] == 'abs'
                            elem.children.each do |elem2|
                                if elem2['class'] == 'site'
                                    host = elem2.text
                                    break
                                end
                            end
                        elsif elem['class'] == 'site'
                            host == elem['href']
                        end
                    end
=end

                    @ranks[id.to_s] = {'href'=>href,'text'=>text,'is_mobile'=>is_mobile,'host'=>host.sub(/\u00A0/,'')}
                end
                @ranks
            end
            def ads_top
                id = 0
                result = []
                @page.search("div[@class='ec_wise_ad']/div").each do |div|
                    id += 1
                    href = div.search("span[@class='ec_site']").first.text
                    href = "http://#{href}"
                    title = div.search("a/text()").text.strip
                    host = Addressable::URI.parse(URI.encode(href)).host
                    result[id] = {'title'=>title,'href'=>href,'host'=>host}
                end
                result
            end
            def ads_right
                []
            end
            def ads_bottom
                []
            end
            def related_keywords
                @related_keywords ||= @page.search("div[@class='relativewords_info']/a").map{|a|a.text}
            end
=begin
            #返回当前页中,符合host条件的结果
            def ranks_for(specific_host)
                host_ranks = Hash.new
                ranks.each do |id,line|
                    if specific_host.class == Regexp
                        host_ranks[id] = line if line['host'] =~ specific_host
                    elsif specific_host.class == String
                        host_ranks[id] = line if line['host'] == specific_host
                    end
                end
                host_ranks
            end
            #return the top rank number from @ranks with the input host
            def rank(host)#on base of ranks
                ranks.each do |id,line|
                    id = id.to_i
                    if host.class == Regexp
                        return id if line['host'] =~ host
                    elsif host.class == String
                        return id if line['host'] == host
                    end
                end
                return nil
            end
=end
            #下一页
            def next
                nextbutton = @page.xpath('//a[text()="下一页"]').first
                return nil if nextbutton.nil?
                url = URI.encode nextbutton['href']
                # puts url
                # p @baseuri
                # exit
                url = URI.join(@baseuri,url).to_s
                page = HTTParty.get(url)
                r = Query::Result::BaiduMobile.new(page)
                r.baseuri=url
                r.pagenumber=@pagenumber+1
                r
            end
        end
    end
end