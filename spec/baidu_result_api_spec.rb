#coding:UTF-8
require 'spec_helper'
describe Query::Result::BaiduMobileApi do
  subject{Query::Result::BaiduMobileApi.new(File.read($sample_mbaidu_api))}

  it "has 3 top ads" do
    subject.ads_top.size.should == 3
  end

  it "'s top ads should be elong,xiecheng and ctrip" do
    subject.ads_top.first[:host].should == 'm.elong.com'
    subject.ads_top[1][:host].should == 'xiecheng.com'
    subject.ads_top[2][:host].should == 'm.ctrip.com'
  end

  it "has 3 bottom ads" do
    subject.ads_bottom.size.should == 3
  end

  it "'s bottom ads should be booking, elong, jingling" do
    subject.ads_bottom[0][:host].should == 'booking.com'
    subject.ads_bottom[1][:host].should == 'touch.elong.cn'
    subject.ads_bottom[2][:host].should == 'jinglinghotel.com'
  end
end