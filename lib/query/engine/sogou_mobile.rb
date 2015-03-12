module Query
  module Engine
    class SogouMobile
      include Query::Engine
      Host = 'wap.sogou.com'
      Options = {
        :headers => {"User-Agent" => 'Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_3_2 like Mac OS X; en-us) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8H7 Safari/6533.18.5'}
      }
      def self.query(wd, params={})
        q = Array.new
        q << "keyword=#{URI.encode(wd)}"
        #q << "rn=#{@perpage.to_i}" if @perpage
        # Join arguments
        params.each do |k, v|
          q << "#{k.to_s}=#{v.to_s}"
        end
        uri = URI::HTTP.build(:host=>Host,:path=>'/web/searchList.jsp',:query=>q.join('&'))
        res = HTTParty.get(uri, Options)
        r = Query::Result::SogouMobile.new(res)
        r.baseuri, r.options = uri, Options  
        r
      end
    end
  end
end
