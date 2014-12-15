#coding:UTF-8
require 'spec_helper'
describe Query::Result::SogouMobile do
    subject{Query::Engine::SogouMobile.query('酒店预订')}
    it "is an instance of #{Query::Result::SogouMobile}" do
        subject.class.should == Query::Result::SogouMobile
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

result = Query::Engine::SogouMobile.query('酒店预订')
ads_top = result.ads_top
describe "types check" do
    it "should return Query::Result::SogouMobile" do
	    result.class.should == Query::Result::SogouMobile
	end

    it "should return Array" do
		ads_top.class.should == Array
    end

    it "should has keys" do
        ads_top[0].should have_key(:rank)
        ads_top[0].has_key?(:domain)
        ads_top[0].has_key?(:host)
        ads_top[0].has_key?(:href)
        ads_top[0].has_key?(:title)
    end
end

describe Query::Result::SogouMobile do
    subject{Query::Engine::SogouMobile.query '中华人民共和国中央人民政府'}

    it "should be an instance of Query::Result::Sogou" do
        subject.class.should == Query::Result::SogouMobile
    end

    # it "'s next page is another instance of Query::Result::Sogou" do
    #     subject.next.class.should == Query::Result::SogouMobile
    # end

    it "have over 1000 results" do
        subject.count.should be_nil
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