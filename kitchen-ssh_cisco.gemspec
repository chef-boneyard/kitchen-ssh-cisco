# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)

Gem::Specification.new do |s|
  s.name          = "kitchen-ssh_cisco"
  s.version     = '0.1.0'
  s.authors       = ["Neill Turner","Carl Perry"]
  s.email         = ["neillwturner@gmail.com","partnereng@chef.io"]
  s.homepage      = "https://github.com/chef-partners/kitchen-ssh-cisco"
  s.add_dependency('minitar', '~> 0.5')
  s.summary       = "ssh driver for test-kitchen for Linux based Cisco platform with an ip address"
  candidates = Dir.glob("{lib}/**/*") +  ['README.md', 'LICENSE.txt', 'kitchen-ssh_cisco.gemspec']
  s.files = candidates.sort
  s.platform      = Gem::Platform::RUBY
  s.require_paths = ['lib']
  s.rubyforge_project = '[none]'
  s.description = <<-EOF
ssh driver for test-kitchen for any Linux based Cisco platform with an ip address

Works the same as kitchen-ssh but adds a prefix_command directive to prefix a string before every command.
Useful for changing network namespace (hint, hint)
EOF

end
