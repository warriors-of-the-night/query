module Query
	module Engine
		class SogouMobile < Base
			BaseUri = 'http://wap.sogou.com/web/searchList.jsp'
			headers = {
				"User-Agent" => 'Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_3_2 like Mac OS X; en-us) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8H7 Safari/6533.18.5'}
			Options = {:headers => headers}
			def query(wd)
				queryStr = "keyword=#{wd}"
				uri = URI.encode(BaseUri + "?" + queryStr)
				res = HTTParty.get(uri,Options)
				Query::Result::SogouMobile.new(res)
			end
		end
	end
end
