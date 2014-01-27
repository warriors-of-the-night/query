module Query
    module Engine
        class Qihu < Base
            Host = 'www.so.com'
            headers = {
                "User-Agent" => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_1) AppleWebKit/537.73.11 (KHTML, like Gecko) Version/7.0.1 Safari/537.73.11'
            }
            Options = {:headers => headers}
            #基本查询, 相当于在搜索框直接数据关键词查询
            def query(wd)
                #用原始路径请求
                uri = URI.join("http://#{Host}/",URI.encode('s?q='+wd)).to_s
                page = HTTParty.get(uri,Options)
                #如果请求地址被跳转,重新获取当前页的URI,可避免翻页错误
                uri = URI.join("http://#{Host}/",page.request.path).to_s
                r = Query::Result::Qihu.new(page)
                r.baseuri = uri
                r
            end
            def self.related_keywords(wd)
                url = "http://rs.so.com/?callback=Search.relate.render&encodein=utf-8&encodeout=utf-8&q="+URI.encode(wd)
                # uri = URI.join("http://#{Host}/",URI.encode('s?q='+wd)).to_s
                page = HTTParty.get(url)
                json_str = page.body
                json_str = json_str.split("(")[1]
                return nil if json_str.nil?
                json_str = json_str.delete(');').strip
                parsed_json = JSON.parse(json_str)
                # each
                # parsed_json.map { |q| p q['q']}
                @related_keywords = parsed_json.map { |q| q['q'] }
                # @related_keywords ||= @page.search("//div[@id=\"rs\"]//tr//a").map{|keyword| keyword.text}
            end
        end
    end
end