class MyFilter
  def contains set, str
    set.to_s.downcase.include?str.downcase
    # set.any? { |x| x.to_s.downcase == str.downcase}
  end
end
require 'query/result'
require 'query/engine'
