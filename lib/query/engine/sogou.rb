module Query
	module Engine
		class Sogou < Base
			BaseUri = 'http://www.sogou.com/web?'
			def query(wd)
				q = []
				q << "query=#{wd}"
				uri = URI.encode BaseUri+q.join('&')
				@page = HTTParty.get uri
				Query::Result::Sogou.new(@page)
			end
		end
	end
end