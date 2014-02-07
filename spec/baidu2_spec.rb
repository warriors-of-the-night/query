#coding:UTF-8
require 'spec_helper'
describe Query::Result::Baidu do
  subject{Query::Result::Baidu.new(File.read($sample_baidu2))}

  it "can click the next page button" do
    subject.next_url.should == '/s?wd=%E9%85%92%E5%BA%97%E9%A2%84%E8%AE%A2%E7%BD%91&pn=10&tn=baiduhome_pg&ie=utf-8&f=3&usm=1&rsv_page=1'
  end

  it "have 100000000 results" do
    subject.count.should == 100000000
  end

  describe '#seo_ranks' do
    it "should put hotel.qunar.com to be on first" do
      subject.seo_ranks.first[:host].should == 'hotel.qunar.com'
    end

    it "should put 北京酒店预订_8371家特惠酒店_百度品质保证_去哪儿网提供 to be the first title" do
      subject.seo_ranks.first[:text].should == '北京酒店预订_8371家特惠酒店_百度品质保证_去哪儿网提供'
    end

    it "should put 'http://jiudian.qunar.com/' to be the second url" do
      subject.seo_ranks[1][:href].should == 'http://www.baidu.com/link?url=ZpGwUrZ8xUUgBQofg1TiNH1n_Ki3QWE62jvjkGvwwZ70wQPxFJxSD1uunh0uDwLM'
    end

    it "should have href,text,host elements for each seo result" do
      subject.seo_ranks.each do |seo_rank|
        seo_rank[:href].should_not == nil
        seo_rank[:text].should_not == nil
        seo_rank[:host].should_not == nil
      end
    end
  end

  describe '#ads_top' do
    it "should have 6 top ads" do
      subject.ads_top.size.should == 4
    end

    it "should find hotel.elong.com at the first position in the top ads" do
      subject.ads_top[0][:host].should == 'www.agoda.com'
    end

    it "has an array of hashes with the required keys as the result of ads_top" do
      subject.ads_top.class.should == Array
      subject.ads_top.each do |ad_top|
        ad_top.should have_key(:rank)
        ad_top.should have_key(:host)
        ad_top.should have_key(:href)
        ad_top.should have_key(:text)
      end
    end
  end

  describe '#ads_right' do
    it "should have 8 right ads" do
      subject.ads_right.size.should == 8
    end

    it "has an array of hashes with the required keys as the result of ads_right" do
      subject.ads_right.class.should == Array
      subject.ads_right.each do |ad_right|
        ad_right.should have_key(:rank)
        ad_right.should have_key(:host)
        ad_right.should have_key(:href)
        ad_right.should have_key(:text)
      end
    end
  end

  describe '#ads_bottom' do
    it "should have zero bottom ads" do
      subject.ads_bottom.size.should == 0
    end

    it "has an array of hashes with the required keys as the result of ads_bottom" do
      subject.ads_bottom.class.should == Array
      subject.ads_bottom.each do |ad_bottom|
        ad_bottom.should have_key(:rank)
        ad_bottom.should have_key(:host)
        ad_bottom.should have_key(:href)
        ad_bottom.should have_key(:text)
      end
    end
  end
end
__END__
describe Query::Engine::Baidu do
    page = Query::Engine::Baidu.query '百度'

    it "should return Query::Result::Baidu" do
        page.class.should == Query::Result::Baidu
    end

    it "should return 100,000,000" do
        page.count.should > 100000
    end
    it "should return 1" do
        page.rank('www.baidu.com').should == 1
    end

    it "should return Query::Result::Baidu" do
        page.next.class.should == Query::Result::Baidu
    end

    it "should return true" do
        bool = Query::Engine::Baidu.popular?'百度'
        bool.should == true
    end

    it "should return false" do
        bool = Query::Engine::Baidu.popular?'lavataliuming'
        bool.should == false
    end

    it "should return over 5 words beginning with the query_word" do
        query_word = '为'
        suggestions = Query::Engine::Baidu.suggestions(query_word)
        suggestions.size.should > 5
        suggestions.each do |suggestion|
            suggestion[0].should == query_word
        end
    end

    it "should return 100,000,000" do
        result = baidu.pages('baidu.com')
        result.class.should == Query::Result::Baidu
        result.count.should == 100000000
    end

    it "should return 100,000,000" do
        result = baidu.links('baidu.com')
        result.class.should == Query::Result::Baidu
        result.count.should == 100000000
    end
    it "should return 100,000,000" do
        result = baidu.pages_with('baidu.com','baidu.com')
        result.class.should == Query::Result::Baidu
        result.count.should == 100000000
    end
    it "查询已经被收录的页面收录情况时,应返回true" do
        baidu.indexed?('http://www.baidu.com').should == true
    end
    it "查询一个不存在的页面收录情况时,应返回true" do
        baidu.indexed?('http://zxv.not-exists.com').should == false
    end
    page1 = Query::Engine::Baidu.query('seoaqua.com')
    it "查询结果应该都能拿到title,href,host" do
        page1.seo_ranks.each do |id,rank|
            rank['href'].should_not == nil
            rank['text'].should_not == nil
            rank['host'].should_not == nil
        end
    end
end