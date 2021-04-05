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

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday", '>= 0.12.1'
  spec.add_dependency "activesupport", '>= 4.2.8'
  spec.add_dependency "activemodel", '>= 4.2.8'
  spec.add_dependency "builder"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake", ">= 12.3.3"
  spec.add_development_dependency "pry", "~> 0.10.4"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "minitest-reporters"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "dotenv"
end
