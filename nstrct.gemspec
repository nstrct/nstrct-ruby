$:.push File.expand_path('../lib', __FILE__)
require 'nstrct/version'

Gem::Specification.new do |s|
  s.name = 'nstrct'
  s.version = Nstrct::VERSION

  s.summary = 'a multi-purpose binary protocol for instruction interchange'
  s.authors = 'Joël Gähwiler'
  s.email = 'nstrct@256dpi.ch'
  s.homepage = 'http://github.com/nstrct'

  s.description = "Interchange formats like json or xml are great to keep data visible, but due to their parse and pack complexity they aren't used in embedded applications. There are alternatives like msgpack or Google's protocol buffer, which allow a more binary representation of data, but these protcols are still heavy and developers tend to rather implement their own 'simple' binary protocols instead of porting or using the big ones."

  s.license = 'MIT'
  
  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")

  s.add_runtime_dependency 'digest-crc'
end
