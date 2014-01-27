module Query
	module Engine
		class Sogou
			include Query::Engine
			BaseUri = 'http://www.sogou.com/web?'
      Options = {
          :headers => {"User-Agent" => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_1) AppleWebKit/537.73.11 (KHTML, like Gecko) Version/7.0.1 Safari/537.73.11'}
      }
			class << self
				def query(wd)
					q = []
					q << "query=#{wd}"
					uri = URI.encode BaseUri+q.join('&')
					page = HTTParty.get(uri,Options)
					r = Query::Result::Sogou.new(page)
					r.baseuri = uri
					r.perpage = @perpage
					r.pagenumber = 1
					r
				end

				def suggestions(word)
					suggestions = HTTParty.get "http://w.sugg.sogou.com/sugg/ajaj_json.jsp?key=#{URI.encode(word)}"
					suggestions = suggestions.encode('utf-8').scan /#{word}[^"]+/
					suggestions
				end

        #site:xxx.yyy.com
				def pages(host)
					query("site:#{host}")
				end

        #domain:xxx.yyy.com/path/file.html
				def links(uri)
					query("domain:\"#{uri}\"")
				end

        #site:xxx.yyy.com inurl:zzz
				# def pages_with(host,string)
    #       query("site:#{host} inurl:#{string}")
				# end
			end
		end
	end
end