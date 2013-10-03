#coding:UTF-8
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
