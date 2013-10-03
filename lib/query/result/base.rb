module Query
    module Result
        class Base
            attr_accessor :baseuri,:pagenumber,:perpage
            def initialize(page)
                @page = Nokogiri::HTML page
                @pagenumber = 1
            end
            # def initialize(page,baseuri,pagenumber=1,perpage=100)
            #     @page = Nokogiri::HTML page
            #     @baseuri = baseuri
            #     # @host = URI(baseuri).host
            #     @pagenumber = pagenumber
            #     @perpage = perpage
            # end
            def whole
                {
                    'ads_top'=>ads_top,
                    'ads_right'=>ads_right,
                    'ads_bottom'=>ads_bottom,
                    'ranks'=>ranks
                }
            end
            #返回当前页中host满足条件的结果
            def ranks_for(specific_host)
                host_ranks = Hash.new
                ranks.each do |id,line|
                    if specific_host.class == Regexp
                        host_ranks[id] = line if line['host'] =~ specific_host
                    elsif specific_host.class == String
                        host_ranks[id] = line if line['host'] == specific_host
                    end
                end
                host_ranks
            end
            #return the top rank number from @ranks with the input host
            def rank(host)#on base of ranks
                ranks.each do |id,line|
                    id = id.to_i
                    if host.class == Regexp
                        return id if line['host'] =~ host
                    elsif host.class == String
                        return id if line['host'] == host
                    end
                end
                return nil
            end
        end
    end
end
