class MyFilter
  def contains set, str
    set.any? { |x| x.to_s.downcase == str.downcase}
  end
end
require 'query/result'
require 'query/engine'
