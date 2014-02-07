#coding:UTF-8
#coding:UTF-8
require 'spec_helper'
describe Query::Result::BaiduMobile do
  subject{Query::Result::BaiduMobile.new(File.read($sample_mbaidu1))}

  it "can click the next page button" do
    subject.next_url.should == 'http://m.baidu.com/from=844b/s?pn=10&usm=3&st=11108i&word=%E9%85%92%E5%BA%97&sa=np&ms=1'
  end

  it "cannot count results" do
    subject.count.should be_nil
  end

  describe '#seo_ranks' do
    it "should put hotel.qunar.com to be on first" do
      subject.seo_ranks.first[:host].should == 'h.qunar.com'
    end

    it "should put 酒店查询与预订 to be the first title" do
      subject.seo_ranks.first[:text].should == '酒店查询与预订'
    end

    it "should put 'http://map.baidu.com/mobile/webapp/search/search/qt=s&wd=%E9%85%92%E5%BA%97&c=131&b=&l=1&center_rank=1&nb_x=&nb_y=/?third_party=webapp-aladdin' to be the second url" do
      subject.seo_ranks[1][:href].should == 'http://map.baidu.com/mobile/webapp/search/search/qt=s&wd=%E9%85%92%E5%BA%97&c=131&b=&l=1&center_rank=1&nb_x=&nb_y=/?third_party=webapp-aladdin'
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
    it "has no top ads" do
      subject.ads_top.size.should == 0
    end

    it "has no top ads" do
      subject.ads_top[0].should be_nil
    end

  end

  describe '#ads_right' do
    it "has no bottom ads" do
      subject.ads_right.size.should == 0
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
    it "has 3 bottom ads" do
      subject.ads_bottom.size.should == 3
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
__END__
require 'spec_helper'
describe Query::Engine::BaiduMobile do
    mbaidu = Query::Engine::BaiduMobile.new
    page = mbaidu.query '百度'
    it "应返回#{Query::Engine::BaiduMobile}" do
        page.class.should == Query::Result::BaiduMobile
    end
    it "下一页也应是Query::Engine::BaiduMobile" do
        page.next.class.should == Query::Result::BaiduMobile
        page.next.next.class.should == Query::Result::BaiduMobile
    end
    it "百度百科域名应该大于1" do
        page.rank('wapbaike.baidu.com').should > 1
    end
    it "百度无线域名应该在10以内" do
        page.rank('m.baidu.com').should < 11
    end
end
