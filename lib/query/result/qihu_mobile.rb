module Query
  module Result
    class QihuMobile
      include Query::Result
      def seo_ranks
      	@page.css('div.g-card').map.with_index do |seo_div,index|
      		begin
      			cite = seo_div.at('.//*[@class="res-show-url"]/text()')
      			a = seo_div.at_css('a')	
      			if cite
      				cite = cite.to_s.gsub(/ |-/,'') 
      			else   
      				url = seo_div.at('.//a[contains(@href,"u=")]') 
      			  if url
					  		cite = URI.decode(CGI.parse(URI(URI.encode(url['href'])).query)['u'][0])
					  		cite = URI(URI.encode(cite)).host
					  	else
					  		cite = "m.haosou.com"
					  	end
          	end
          	title = seo_div.at_css('h3') || a        	
          	{	
          		:is_vr => seo_div['class']=="g-card r-og-card" ? false : true,
            	:rank  => index + 1 + (@pagenumber-1)*10,
            	:href  => a['href'],
            	:text  => title.text.gsub(/　|\n|\s/,""),
            	:host  => cite
          	}
          rescue Exception => e
          	warn "Error in parse_seo method : " + e.message
          	{}
          end
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
