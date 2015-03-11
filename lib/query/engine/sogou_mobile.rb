module Query
	module Engine
		class SogouMobile
			include Query::Engine
			Host = 'http://wap.sogou.com'
			Options = {
				:headers => {"User-Agent" => 'Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_3_2 like Mac OS X; en-us) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8H7 Safari/6533.18.5'}
			}
			def self.query(wd)
				path = "/web/searchList.jsp?keyword=#{wd}"
				uri = URI.encode(Host + path)
				res = HTTParty.get(uri, Options)
				r = Query::Result::SogouMobile.new(res)
				r.baseuri, r.options = URI(uri), Options  
				r
			end
		end
	end
end
