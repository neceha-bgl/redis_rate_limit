# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'redis_rate_limit/version'

Gem::Specification.new do |spec|
  spec.name          = 'redis_rate_limit'
  spec.version       = RedisRateLimit::VERSION
  spec.authors       = ['neceha-bgl']
  spec.email         = ['neceha.bgl@gmail.com']
  spec.summary       = 'Rate Limit controler based on Redis'
  spec.description   = 'Controle the number of requests permitted to make per minute/hour/day'
  spec.homepage      = 'https://github.com/neceha-bgl/redis_rate_limit'
  spec.license       = 'MIT'
  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency             'redis'
  spec.add_dependency             'rubocop'
  spec.add_development_dependency 'fakeredis',  '~> 0.3.0'
  spec.add_development_dependency 'activesupport'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'fuubar'
  spec.add_development_dependency 'timecop'
  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'yard'
end
