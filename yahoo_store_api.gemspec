# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'yahoo_store_api/version'

Gem::Specification.new do |spec|
  spec.name          = "yahoo_store_api"
  spec.version       = YahooStoreApi::VERSION
  spec.authors       = ["t4traw"]
  spec.email         = ["t4traw@gmail.com"]

  spec.summary       = %q{Yahoo!ショッピング プロフェッショナル出店ストア向けAPIを簡単に叩けるrubyラッパー}
  spec.description   = %q{Yahoo!ショッピング プロフェッショナル出店ストア向けAPIを簡単に叩けるrubyラッパー}
  spec.homepage      = "https://github.com/t4traw/yahoo_store_api"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday", '~> 0.12.1'
  spec.add_dependency "activesupport", '~> 5.1.0'
  spec.add_dependency "activemodel", '~> 5.1.0'
  spec.add_dependency "builder"
  spec.add_dependency "oga", '~> 2.10'

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry", "~> 0.10.4"
end
