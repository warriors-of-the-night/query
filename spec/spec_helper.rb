require 'query'
require 'pathname'
require 'awesome_print'
path_root = Pathname.new(__dir__)
path_samples = File.join(path_root,'samples')
$sample_qihu = File.join(path_samples,'qihu.html')
$sample_sogou = File.join(path_samples,'sogou.html')
$sample_msogou = File.join(path_samples,'msogou.html')