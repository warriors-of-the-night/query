module Query
    module Engine
        class Baidu
            include Query::Engine
            BaseUri = 'http://www.baidu.com/s?'
            Options = {
                :headers => {"User-Agent" => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_1) AppleWebKit/537.73.11 (KHTML, like Gecko) Version/7.0.1 Safari/537.73.11'}
            }
            def self.suggestions(wd)
                require 'json'
                json = HTTParty.get("http://suggestion.baidu.com/su?wd=#{URI.encode(wd)}&cb=callback").force_encoding('GBK').encode("UTF-8")
                m = /\[([^\]]*)\]/.match json
                return JSON.parse m[0]
            end
            #to find out the real url for something lik 'www.baidu.com/link?url=7yoYGJqjJ4zBBpC8yDF8xDhctimd_UkfF8AVaJRPKduy2ypxVG18aRB5L6D558y3MjT_Ko0nqFgkMoS'
            # def url(id)
            #   a = Mechanize.new
            #   a.redirect_ok=false
            #   return a.head("http://www.baidu.com/link?url=#{id}").header['location']
            # end

=begin
            def extend(words,level=3,sleeptime=1)
                level = level.to_i - 1
                words = [words] unless words.respond_to? 'each'

                extensions = Array.new
                words.each do |word|
                    self.query(word)
                    extensions += related_keywords
                    extensions += suggestions(word)
                    sleep sleeptime
                end
                extensions.uniq!
                return extensions if level < 1
                return extensions + extend(extensions,level)
            end
=end

            def self.popular?(wd)
                return HTTParty.get("http://index.baidu.com/main/word.php?word=#{URI.encode(wd.encode("GBK"))}").include?"boxFlash"
            end

            def self.query(wd)
                q = Array.new
                q << "wd=#{wd}"
                q << "rn=#{@perpage.to_i}" if @perpage
                queryStr = q.join("&")
                #uri = URI.encode((BaseUri + queryStr).encode('GBK'))
                uri = URI.encode((BaseUri + queryStr))
                # begin
                    # @page = @a.get uri
                    @page = HTTParty.get(uri,Options)
                    r = Query::Result::Baidu.new(@page)
                    r.baseuri = uri
                    r.pagenumber = 1
                    r.perpage = @perpage
                    r
                # rescue Exception => e
                #     warn e.to_s
                #     return false
                # end
=begin
                query = "#{query}"
                @uri = BaseUri+URI.encode(query.encode('GBK'))
                @page = @a.get @uri
                self.clean
                @number = self.how_many
                @maxpage = (@number / @perpage.to_f).round
                @maxpage =10 if @maxpage>10
                @currpage =0
=end
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
            def pages_with(host,string)
                query("site:#{host} inurl:#{string}")
            end
        end
    end
end