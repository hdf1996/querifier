
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "querifier/version"

Gem::Specification.new do |spec|
  spec.name          = "querifier"
  spec.version       = Querifier::VERSION
  spec.authors       = ["Hugo Farji"]
  spec.email         = ["hugo.farji@gmail.com"]

  # TODO
  spec.summary       = %q{ Write a short summary, because RubyGems requires one.}
  # TODO
  spec.description   = %q{ Write a longer description or delete this line.}
  # TODO
  spec.homepage      = "https://google.com.ar"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'railties', '>= 4.1.0', '< 6'
end
