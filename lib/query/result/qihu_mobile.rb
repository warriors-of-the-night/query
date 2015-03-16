module Query
  module Result
    class QihuMobile
      include Query::Result
      def seo_ranks
      	@page.css('div.g-card').map.with_index do |seo_div,index|
      		a = seo_div.at('.//a[contains(@href,"u=")]')
          title = seo_div.at_css('h3') || a
          cite = seo_div.at('.//*[@class="res-show-url"]/text()')
          cite = URI.decode(CGI.parse(URI(URI.encode(a['href'])).query)['u'][0]) if !cite
          cite = "http://" + cite.to_s if !cite.to_s[/http/]
          {	:is_vr => seo_div['class']=="g-card r-og-card" ? true : false,
            :rank  => index + 1,
            :href  => a['href'],
            :text  => title.text.gsub(/　|\n|\s/,""),
            :host  => URI(URI.encode(cite.gsub(/ |-/,''))).host
          }
        end
      end
      
      def next_url
       "#{@baseuri.to_s}&pn=#{@pagenumber+1}"
      end
      
      def html
        @page.to_html
      end

    end
  end
end
