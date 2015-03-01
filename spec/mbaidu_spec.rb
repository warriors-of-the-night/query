require 'spec_helper'
describe Query::Result::BaiduMobile do
  subject{Query::Result::BaiduMobile.new(File.read($sample_mbaidu))}

    it "should put 酒店查询与预订 to be the first title" do
      subject.seo_ranks.first[:text].should == '酒店查询与预订'
    end
end