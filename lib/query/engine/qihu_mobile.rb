module Query
	module Engine
		class QihuMobile
			Host = "m.haosou.com"
      Options = {
        :headers => {"User-Agent" => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_1) AppleWebKit/537.73.11 (KHTML, like Gecko) Version/7.0.1 Safari/537.73.11'}
        }
      def self.query(wd, params={})
        q = Array.new
        q << "q=#{URI.encode(wd)}"
        #q << "rn=#{@perpage.to_i}" if @perpage
        # Join arguments
        params.each do |k, v|
          q << "#{k.to_s}=#{v.to_s}"
        end
        uri = URI::HTTP.build(:host=>Host,:path=>'/s',:query=>q.join('&'))
        res = HTTParty.get(uri, Options)
        r = Query::Result::QihuMobile.new(res)
        r.baseuri, r.options = uri, Options  
        r
      end
    end
  end
end
