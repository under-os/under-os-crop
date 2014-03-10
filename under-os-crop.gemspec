# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.name          = "under-os-image"
  gem.version       = '0.0.0'

  gem.authors       = ["Nikolay Nemshilov"]
  gem.email         = ['nemshilov@gmail.com']
  gem.description   = "The images crop UI for UnderOS"
  gem.summary       = "The images crop UI for UnderOS. Like totes"
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($/).reject{|f| f.slice(0,5) == 'gems/'}
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})

  gem.add_runtime_dependency 'under-os-ui'
  gem.add_development_dependency 'rake'

end
