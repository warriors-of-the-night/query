#coding:UTF-8
require 'spec_helper'
describe Query::Result::Qihu do
  subject{Query::Result::Qihu.new(File.read($sample_qihu))}

  it "can click the next page button" do
    subject.next_url.should == 's?q=%E9%85%92%E5%BA%97&pn=2&j=0&ls=0&src=srp_paging&fr=360sou_home'
  end

  it "have over 1000 results" do
    subject.count > 1000
  end

  describe '#seo_ranks' do
    it "should put u.ctrip.com to be on first" do
      subject.seo_ranks.first[:host].should == 'u.ctrip.com'
    end

    it "should put '合肥酒店查询预订_携程酒店 to be the first title" do
      subject.seo_ranks.first[:text].should == '合肥酒店查询预订_携程酒店'
    end

    it "should put 'http://jiudian.qunar.com/' to be the second url" do
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
    it "should have 3 top ads" do
      subject.ads_top.size.should == 3
    end

    it "should find hotel.elong.com at the first position in the top ads" do
      subject.ads_top[0][:host].should == 'www.booking.com'
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
