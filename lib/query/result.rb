module Query
  module Result
    attr_accessor :baseuri,:pagenumber,:perpage,:options
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
      return false unless next_url
      @next_url = URI.join(@baseuri, next_url)
      next_page = HTTParty.get(@next_url, @options)
      r = self.class.new(next_page)
      r.pagenumber, r.perpage, r.options, r.baseuri = @pagenumber + 1, @perpage, @options, @baseuri
      r
    end
  end
end
require "nokogiri"
require "addressable/uri"