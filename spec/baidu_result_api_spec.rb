#coding:UTF-8
require 'spec_helper'
describe Query::Result::Baidu do
  subject{Query::Result::Baidu.new(File.read($sample_baidu_api))}

  describe '#ads_top' do
    specify{subject.ads_top.size.should == 3 }
  end

  describe '#ads_left' do
    specify{subject.ads_left.size.should == 6 }
  end
end