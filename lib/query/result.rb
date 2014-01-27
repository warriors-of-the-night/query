module Query
  module Result
    attr_accessor :baseuri,:pagenumber,:perpage
    def initialize(page)
      @page = Nokogiri::HTML page
      @pagenumber = 1
    end
    def raw_ranks
      {
        'ads_top'=>ads_top,
        'ads_right'=>ads_right,
        'ads_bottom'=>ads_bottom,
        'seo_ranks'=>seo_ranks
      }
    end

    def rank(host)#on base of ranks
      @rank ||= %w(seo_ranks ads_top ads_right ads_bottom).map do |type_str|
        result = nil
        send(type_str).each_with_index do |line,index|
          if host.class == Regexp
            result = index + 1 and break if line[:host] =~ host
          elsif host.class == String
            result = index + 1 and break if line[:host] == host
          else
            result = false
          end
        end
        result
      end
    end

    def next
      @next_url = URI.join(@baseuri,next_url).to_s
      next_page = HTTParty.get @next_url
      next_page = self.class.new(next_page)
      next_page.baseuri = @next_url
      next_page.pagenumber = @pagenumber + 1
      next_page.perpage = @perpage
      r = next_page
      r.baseuri = next_url
      r
    end
  end
end
require 'nokogiri'
require "addressable/uri"
require 'query/result/baidu'
require 'query/result/baidu_mobile'
require 'query/result/qihu'
require 'query/result/qihu_mobile'
require 'query/result/sogou'
require 'query/result/sogou_mobile'
