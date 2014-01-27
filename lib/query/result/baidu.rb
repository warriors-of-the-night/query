module Query
    module Result
        class Baidu
            include Query::Result
            def seo_ranks
                return @ranks unless @ranks.nil?
                @ranks = Hash.new
                @page.search("//table[@class=\"result\"]|//table[@class=\"result-op\"]").each do |table|
                    id = table['id']
                    # if @perpage == 10
                    #     id = table['id'][-1,1]
                    #     id = '10' if id == '0'
                    # end

                    @ranks[id] = Hash.new
                    url = table.search("[@class=\"g\"]").first
                    url = url.text unless url.nil?
                    a = table.search("h3").first
                    next if a.nil?
                    @ranks[id]['text'] = a.text
                    @ranks[id]['href'] = url #a.first['href'].sub('http://www.baidu.com/link?url=','').strip
                    unless url.nil?
                        url = url.strip
                        @ranks[id]['host'] = Addressable::URI.parse(URI.encode("http://#{url}")).host
                    else
                        @ranks[id]['host'] = nil
                    end
                end
                #@page.search("//table[@class=\"result\"]").map{|table|@page.search("//table[@id=\"#{table['id']}\"]//span[@class=\"g\"]").first}.map{|rank|URI(URI.encode('http://'+rank.text.strip)).host unless rank.nil?}
                @ranks
            end

            def ads_bottom
                return {} if @page.search("//table[@bgcolor='f5f5f5']").empty?
                return ads_top
                # p @page.search("//table[@bgcolor='f5f5f5']").empty?
            end
            def ads_top
                #灰色底推广,上下都有
                ads = Hash.new
                @page.search("//table[@bgcolor='#f5f5f5']").each do |table|
                    id = table['id']
                    next if id.nil?
                    id = id[2,3].to_i.to_s
                    ads[id]= parse_ad(table)
                end
                #白色底推广,只有上部分
                if ads.empty?
                    @page.search("//table").each do |table|
                        id = table['id']
                        next if id.nil? or id.to_i<3000
                        id = id[2,3].to_i.to_s
                        ads[id]= parse_ad(table)
                    end
                end
                ads
            end

            def ads_right
                ads = {}
                @page.search("//div[@id='ec_im_container']").each do |table|
                    table.search("div[@id]").each do |div|
                        id = div['id'][-1,1].to_i+1
                        title = div.search("a").first
                        next if title.nil?
                        title = title.text
                        url = div.search("font[@color='#008000']").first
                        next if url.nil?
                        url = url.text
                        ads[id.to_s] = {'title'=>title,'href'=>url,'host'=>url}
                    end
                end
                ads
            end

            #return the top rank number from @ranks with the input host
            # def rank(host)#on base of ranks
            #     ranks.each do |id,line|
            #         id = id.to_i
            #         if host.class == Regexp
            #             return id if line['host'] =~ host
            #         elsif host.class == String
            #             return id if line['host'] == host
            #         end
            #     end
            #     return nil
            # end

            def count
                @count ||= @page.search("//span[@class='nums']").map{|num|num.content.gsub(/\D/,'').to_i unless num.nil?}.first
            end

            def related_keywords
                @related_keywords ||= @page.search("//div[@id=\"rs\"]//tr//a").map{|keyword| keyword.text}
            end

            # def next
            #     url = @page.xpath('//a[text()="下一页>"]').first
            #     return if url.nil?
            #     url = url['href']
            #     url = URI.join(@baseuri,url).to_s
            #     page = HTTParty.get(url)
            #     r = Query::Result::Baidu.new(page)
            #     r.baseuri = url
            #     r.pagenumber=@pagenumber+1
            #     r.perpage=@perpage
            #     r

            #     # @page = BaiduResult.new(Mechanize.new.click(@page.link_with(:text=>/下一页/))) unless @page.link_with(:text=>/下一页/).nil?
            # end
            def has_result?
                submit = @page.search('//a[text()="提交网址"]').first
                return false if submit and submit['href'].include?'sitesubmit'
                return true
            end
            private
            def parse_ad(table)
                href = table.search("font[@color='#008000']").text.split(/\s/).first.strip
                title = table.search("a").first.text.strip
                {'title'=>title,'href' => href,'host'=>href}
            end
        end
    end
end