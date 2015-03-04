module Query
  module Engine
    class BaiduMobile
      include Query::Engine
      Host = 'm.baidu.com'
      Options = {
        :headers => {"User-Agent" => 'Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_3_2 like Mac OS X; en-us) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8H7 Safari/6533.18.5'}
      }

      #基本查询,相当于从搜索框直接输入关键词查询
      def self.query(wd, params={})
        q = Array.new
        q << "word=#{URI.encode(wd)}"
        q << "rn=#{@perpage.to_i}" if @perpage
        # Join arguments
        params.each do |k, v|
          q << "#{k.to_s}=#{v.to_s}"
        end
        uri = URI::HTTP.build(:host=>Host,:path=>'/s',:query=>q.join('&'))
        # begin
          res = HTTParty.get(uri, Options)
          r = Query::Result::BaiduMobile.new(res)
          r.baseuri, r.options = uri, Options  
          r
        # rescue Exception => e
            # warn "#{__FILE__} #{__LINE__} #{uri} fetch error: #{e.to_s}"
            # return false
        # end
      end            
    end
  end
end