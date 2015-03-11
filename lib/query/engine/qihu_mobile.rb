module Query
	module Engine
		class QihuMobile
			Host = "m.haosou.com"
      Options = {
        :headers => {"User-Agent" => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_1) AppleWebKit/537.73.11 (KHTML, like Gecko) Version/7.0.1 Safari/537.73.11'}
        }
      def self.query(wd)
        uri = URI.join("http://#{Host}/", URI.encode('s?q='+wd))
        page = HTTParty.get(uri, Options)
        #如果请求地址被跳转,重新获取当前页的URI,可避免翻页错误
        uri = URI.join("http://#{Host}/", page.request.path)
        r = Query::Result::Qihu.new(page)
        r.baseuri = uri
        r.options = Options
        r
      end
    end
  end
end
