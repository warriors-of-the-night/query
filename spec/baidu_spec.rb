#coding:UTF-8
require 'spec_helper'
describe Query::Engine::Baidu do
    baidu = Query::Engine::Baidu.new
    page = baidu.query '百度'

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
    page1 = baidu.query('seoaqua.com')
    it "查询结果应该都能拿到title,href,host" do
        page1.ranks.each do |id,rank|
            rank['href'].should_not == nil
            rank['text'].should_not == nil
            rank['host'].should_not == nil
        end
    end
    # ads_page = baidu.query '减肥药'

end