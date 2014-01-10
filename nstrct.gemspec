$:.push File.expand_path('../lib', __FILE__)
require 'nstrct/version'

Gem::Specification.new do |s|
  s.name = 'nstrct'
  s.version = Nstrct::VERSION

  s.summary = 'a multi-purpose binary protocol for instruction interchange'
  s.authors = 'Joël Gähwiler'
  
  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")

  s.add_runtime_dependency 'digest-crc'
end
