module Query
    module Engine
        class Base
            attr_accessor :perpage
           #是否收录
            # def initialize(perpage = 100)
            #     @perpage = perpage#只允许10或100
            # end
            def indexed?(url)
                URI(url)
                result = query(url)
                return result.has_result?
            end
        end
    end
end