require_relative 'lib/auxiliary_rails_resourceable/version'

Gem::Specification.new do |spec|
  spec.name    = 'auxiliary_rails_resourceable'
  spec.version = AuxiliaryRailsResourceable::VERSION
  spec.authors = ['Dmitry Babenko', 'ErgoServ']
  spec.email   = ['dmitry@ergoserv.com', 'hello@ergoserv.com']

  spec.summary  = 'AuxiliaryRails - Resourceable Controller'
  spec.homepage = 'https://github.com/ergoserv/auxiliary_rails_resourceable'
  spec.license  = 'MIT'
  spec.required_ruby_version = '>= 2.5'

  spec.metadata['homepage_uri']    = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri']   = spec.homepage
  spec.metadata['rubygems_mfa_required'] = 'true'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'pagy', '>= 6.0.4'
  spec.add_dependency 'pundit', '>= 2.2'
  spec.add_dependency 'rails', '>= 5.2'
  spec.add_dependency 'ransack', '>= 3.0.0'
end
