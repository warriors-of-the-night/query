#coding:UTF-8
require 'spec_helper'
describe Query::Result::Baidu do
  subject{Query::Result::Baidu.new(File.read($sample_mbaidu_api))}

  describe '#ads_top' do
    it "finds 3 ads on top" do
      expect(subject.ads_top.size).to  eq 3
    end
  end

  describe '#ads_left' do
    it "finds 6 ads on the bottom" do
      expect(subject.ads_left.size).to  eq 6
    end
  end
end
