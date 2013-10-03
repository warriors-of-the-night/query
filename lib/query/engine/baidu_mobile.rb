module Query
    module Engine
        class BaiduMobile < Base
            BaseUri = 'http://m.baidu.com/s?'
            headers = {
                "User-Agent" => 'Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_3_2 like Mac OS X; en-us) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8H7 Safari/6533.18.5'
            }
            Options = {:headers => headers}

            #基本查询,相当于从搜索框直接输入关键词查询
            def query(wd)
                queryStr = "word=#{wd}"
                uri = URI.encode((BaseUri + queryStr))
                # begin
                    res = HTTParty.get(uri,Options)
                    r = Query::Result::BaiduMobile.new(res)
                    r.baseuri = uri
                    r
                # rescue Exception => e
                    # warn "#{__FILE__} #{__LINE__} #{uri} fetch error: #{e.to_s}"
                    # return false
                # end
            end
        end
    end
end