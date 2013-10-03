module Query
    module Result
        class Qihoo < Base
            # include Query::Result
            Host = 'www.so.com'
            #返回所有当前页的排名结果
            def ranks
                return @ranks unless @ranks.nil?
                @ranks = Hash.new
                # id = (@pagenumber - 1) * 10
                id = 0
                @page.search('//li[@class="res-list"]').each do |li|
                    a = li.search("h3/a").first
                    url = li.search("cite")
                    next if a['data-pos'].nil?
                    id += 1
                    text = a.text.strip
                    href = a['href']
                    url = url.first.text
                    host = Addressable::URI.parse(URI.encode("http://#{url}")).host
                    @ranks[id.to_s] = {'href'=>a['href'],'text'=>text,'host'=>host}
                end
                @ranks
            end
            def ads_top
                id = 0
                result = []
                @page.search("//ul[@id='djbox']/li").each do |li|
                    id += 1
                    title = li.search("a").first.text
                    href = li.search("cite").first.text.downcase
                    host = Addressable::URI.parse(URI.encode(href)).host
                    result[id] = {'title'=>title,'href'=>href,'host'=>host}
                end
                result
            end
            def ads_bottom
                []
            end
            def ads_right
                id = 0
                result = []
                @page.search("//ul[@id='rightbox']/li").each do |li|
                    id += 1
                    title = li.search("a").first.text
                    href = li.search("cite").first.text.downcase
                    host = Addressable::URI.parse(URI.encode(href)).host
                    result[id] = {'title'=>title,'href'=>href,'host'=>host}
                end
                result
            end
            def related_keywords
                []
            end
            #下一页
            def next
                next_href = @page.xpath('//a[@id="snext"]')
                return false if next_href.empty?
                next_href = next_href.first['href']
                next_href = URI.join(@baseuri,next_href).to_s
                # next_href = URI.join("http://#{@host}",next_href).to_s
                next_page = HTTParty.get(next_href).next
                r =Query::Result::Qihoo.new(next_page)
                r.baseuri=next_href
                r.pagenumber=@pagenumber+1
                r
                #@page = MbaiduResult.new(Mechanize.new.click(@page.link_with(:text=>/下一页/))) unless @page.link_with(:text=>/下一页/).nil?
            end
            #有结果
            def has_result?
                !@page.search('//div[@id="main"]/h3').text().include?'没有找到该URL'
            end
        end
    end
end