# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'acmesmith-digital-ocean-dns/version'

Gem::Specification.new do |spec|
  spec.name          = "acmesmith-digital-ocean-dns"
  spec.version       = AcmesmithDigitalOceanDns::VERSION
  spec.authors       = ["usiegl00"]
  spec.email         = ["50933431+usiegl00@users.noreply.github.com"]

  spec.summary       = %q{acmesmith plugin implementing dns-01 using DigitalOcean DNS}
  spec.description   = %q{This gem is a plugin for acmesmith and implements an automated dns-01 challenge responder using DigitalOcean DNS}
  spec.homepage      = "https://github.com/usiegl00/acmesmith-digital-ocean-dns"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "acmesmith", "~> 2.0"
  spec.add_dependency "droplet_kit"
end
