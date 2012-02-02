Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_yandex_market'
  s.version     = '1.1.1'
  s.summary     = 'Export products to Yandex.Market'
  #s.description = 'Add (optional) gem description here'
  s.required_ruby_version = '>= 1.8.7'

  # s.author            = 'David Heinemeier Hansson'
  # s.email             = 'david@loudthinking.com'
  # s.homepage          = 'http://www.rubyonrails.org'
  # s.rubyforge_project = 'actionmailer'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.has_rdoc = true

  s.add_dependency('spree_core', '>= 1.0.0.rc2')
  s.add_dependency('nokogiri', '~> 1.5.0')
end
