module Query
  module Engine
    attr_accessor :perpage
    def self.indexed?(url)
      URI(url)
      result = query(url)
      return result.has_result?
    end
  end
end
