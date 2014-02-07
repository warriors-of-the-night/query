#coding:UTF-8
require 'spec_helper'

describe Query::Result::Sogou do
    subject{Query::Result::Sogou.new(File.read($sample_sogou))}

    it "has an array of hashes with the required keys as the result of ads_top" do
        subject.ads_top.class.should == Array
        subject.ads_top.each do |ad_top|
            ad_top.should have_key(:rank)
            ad_top.should have_key(:host)
            ad_top.should have_key(:href)
            ad_top.should have_key(:text)
        end
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

describe Query::Result::Sogou do
    subject{Query::Engine::Sogou.query '中华人民共和国中央人民政府'}

    it "should be an instance of Query::Result::Sogou" do
        subject.class.should == Query::Result::Sogou
    end

    it "'s next page is another instance of Query::Result::Sogou" do
        subject.next.class.should == Query::Result::Sogou
    end

    it "have over 1000 results" do
        subject.count.should > 1000
    end

    it "puts www.gov.cn to the first place of seo_ranks" do
        subject.rank('www.gov.cn')[0].should == 1
    end

    it "should have href,text,host elements for each seo result" do
        subject.seo_ranks.each do |seo_rank|
            seo_rank[:href].should_not == nil
            seo_rank[:text].should_not == nil
            seo_rank[:host].should_not == nil
        end
    end
end

describe Query::Engine::Sogou do
    subject{Query::Engine::Sogou}

    it "have more than 1 million baidu.com pages indexed" do
        result = subject.pages('baidu.com')
        result.class.should == Query::Result::Sogou
        result.count.should > 1000000
    end

    it "have more than 100 links to baidu.com" do
        result = subject.links('baidu.com')
        result.class.should == Query::Result::Sogou
        result.count.should > 100
    end

    it "查询已经被收录的页面收录情况时,应返回true" do
        pending
        subject.indexed?('http://www.baidu.com').should == true
    end

    it "查询一个不存在的页面收录情况时,应返回true" do
        pending
        subject.indexed?('http://zxv.not-exists.com').should == false
    end

    describe '#suggestions' do
        query = '搜狗'
        subject{Query::Engine::Sogou.suggestions(query)}
        it 'should have more than one suggestions' do
            subject.size.should > 1
        end

        it 'gives all suggestions with the query word at the start' do
            subject.each do |suggestion|
                suggestion.should start_with query
                # (suggestion.start_with?query).should_be true
            end
        end
    end
end

