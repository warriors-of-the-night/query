#coding:UTF-8
require 'spec_helper'
describe Query::Result::QihuMobile do
    subject{Query::Engine::QihuMobile.query('酒店预订')}
    it "is an instance of #{Query::Result::QihuMobile}" do
        subject.class.should == Query::Result::QihuMobile
    end  
    
    it "has an array of related_keywords" do
        subject.related_keywords.class.should == Array
        expect(subject.related_keywords.size).not_to eq 0
    end
    
    it "has the url of next page" do
      expect(subject.next_url).to eq "http://m.haosou.com/s?q=%E9%85%92%E5%BA%97%E9%A2%84%E8%AE%A2&pn=2"
    end
end

describe Query::Result::QihuMobile do
    subject{Query::Engine::QihuMobile.query '酒店预订'}

    it "should be an instance of Query::Result::QihuMobile" do
        subject.class.should == Query::Result::QihuMobile
    end

    it "should have href,text,host elements for each seo result" do
        subject.seo_ranks.each do |seo_rank|
            seo_rank[:href].should_not == nil
            seo_rank[:text].should_not == nil
            seo_rank[:host].should_not == nil
        end
    end
end
