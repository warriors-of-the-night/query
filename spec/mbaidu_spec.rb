require 'spec_helper'
describe Query::Result::BaiduMobile do
  sample = Query::Result::BaiduMobile.new(File.read($sample_mbaidu))
  it "cannot count results" do
    expect(sample.count).to eq nil
  end

  it "canot get url of next page" do
    expect(sample.next_url).not_to eq nil
  end

  describe '#seo_ranks' do
    it "should put hotel.qunar.com to be on first" do
     expect(sample.seo_ranks.first[:host]).to eq 'touch.qunar.com'
    end

    it "should put 酒店查询与预订 to be the first title" do
      expect(sample.seo_ranks.first[:text]).to eq '酒店查询与预订'
    end

    it "should have href,text,host,is_vr elements for each seo result" do
      sample.seo_ranks.each do |seo_rank|
        expect(seo_rank[:href]).not_to eq nil
        expect(seo_rank[:text]).not_to eq nil
        expect(seo_rank[:host]).not_to eq nil
      end
    end
  end
  describe '#ads_top' do
    it "should put 携程网-酒店全场酒店2折起 to be the first ads_top title" do
      expect(sample.ads_top.first[:text]).to eq '携程网-酒店全场酒店2折起!'
    end

    it "should have 3 ads item" do
     expect(sample.ads_top.size).to eq 3
    end

     it "has an array of hashes with the required keys as the result of ads_top" do
      sample.ads_top.each do |ad_top|
        ad_top.should have_key(:rank)
        ad_top.should have_key(:host)
        ad_top.should have_key(:href)
        ad_top.should have_key(:text)
      end
    end
  end

  describe '#ads_bottom' do 
    it "didn't have bottom ads" do
     expect(sample.ads_bottom.size).to eq 0
    end

     it "has an array of hashes with the required keys as the result of ads_top" do
      sample.ads_bottom.each do |ads_bottom|
        ads_bottom.should have_key(:rank)
        ads_bottom.should have_key(:host)
        ads_bottom.should have_key(:href)
        ads_bottom.should have_key(:text)
      end
    end
  end
end
