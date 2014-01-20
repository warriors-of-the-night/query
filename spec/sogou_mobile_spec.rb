#coding:UTF-8
require 'spec_helper'
sogou = Query::Engine::SogouMobile.new
result = sogou.query('酒店预订')
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
