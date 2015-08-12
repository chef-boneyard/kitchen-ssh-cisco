Gem::Specification.new do |s|
  s.name        = 'kitchen-ssh2'
  s.version     = '0.1.0'
  s.date        = '2015-08-11'
  s.summary     = "Enhanced SSH driver for TK"
  s.description = "Enhanced SSH driver for Test Kitchen, based partially on kitchen-ssh but for TK 1.4 and up"
  s.authors     = ["Carl Perry"]
  s.email       = 'cperry@chef.io'
  s.files       = [
    "lib/kitchen/driver/ssh2.rb",
  ]
  s.homepage    =
    'http://rubygems.org/gems/hola'
  s.license       = 'Apache2'

  s.add_dependency 'test-kitchen', '~> 1.4', '>= 1.4.1'
end
