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
require 'httparty'
require 'query/engine/baidu'
require 'query/engine/baidu_mobile'
require 'query/engine/qihu'
require 'query/engine/qihu_mobile'
require 'query/engine/sogou'
require 'query/engine/sogou_mobile'