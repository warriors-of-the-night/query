#coding:UTF-8
require 'spec_helper'
describe Query::Result::SogouMobile do
  subject{Query::Result::SogouMobile.new(File.read($sample_msogou))}

  it "can click the next page button" do
    subject.next_url.should == './searchList.jsp?p=2&type=1&keyword=%E9%85%92%E5%BA%97%E9%A2%84%E8%AE%A2&uID=-xn_vif1ZEBEHaV4&sz=2-2&v=5&suuid=0946c9c5-f40d-42e0-ad2a-06e31fa97436'
  end

  it "have over 1000 results" do
    subject.count.should be_nil
  end


  describe '#seo_ranks' do
    it "should put u.ctrip.com to be on first" do
      pending('sogou vr干扰')
      subject.seo_ranks.first[:host].should == 'm.ctrip.com'
    end

    it "should put 北京酒店查询预订_携程旅行网 to be the first title" do
      pending('sogou vr干扰')
      subject.seo_ranks.first[:text].should == '北京酒店查询预订_携程旅行网 '
    end

    it "should put 'http://jiudian.qunar.com/' to be the second url" do
      pending('sogou vr干扰')
      subject.seo_ranks[1][:href].should == 'http://jiudian.qunar.com/'
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
      subject.ads_top.size.should == 3
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