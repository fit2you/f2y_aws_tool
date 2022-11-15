# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'f2y_aws_tool/version'

Gem::Specification.new do |spec|
  spec.name          = "f2y_aws_tool"
  spec.version       = F2yAwsTool::VERSION
  spec.authors       = ["nakedmoon"]
  spec.email         = ["tore.andrea@gmail.com"]

  spec.summary       = %q{F2Y Aws Tool.}
  spec.description   = %q{Fit2You Amazon Web Services Tool.}
  spec.homepage      = "http://www.fit2you.it"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", ">= 12.3.3"

  # Custom gemspecs
  spec.add_development_dependency "rspec", "3.5.0"
  spec.add_development_dependency "byebug", "9.0.6"
  spec.add_runtime_dependency "log4r", "1.1.10"
  spec.add_runtime_dependency "thor", ">= 0.19.4", "< 2.0"
  spec.add_runtime_dependency "aws-sdk", ">= 3.1"
  spec.executables << "f2y-aws-tool"
  spec.add_runtime_dependency "activesupport", ">= 4.2", "<= 7.0.3"
end
