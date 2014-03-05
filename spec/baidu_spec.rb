require 'spec_helper'
describe Query::Engine::Baidu do
    page = Query::Engine::Baidu.query '百度'

    specify{page.class.should == Query::Result::Baidu }

    specify{page.count.should > 100000 }

    specify{page.raw_ranks.class.should == Hash}

    specify{page.next.class.should == Query::Result::Baidu }
end