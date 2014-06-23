# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "pry-byebug"
  s.version = "1.3.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["David Rodr\u{ed}guez", "Gopal Patel"]
  s.date = "2014-02-24"
  s.description = "Combine 'pry' with 'byebug'. Adds 'step', 'next', and\n    'continue' commands to control execution."
  s.email = "deivid.rodriguez@gmail.com"
  s.homepage = "https://github.com/deivid-rodriguez/pry-byebug"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 2.0.0")
  s.rubygems_version = "2.0.14"
  s.summary = "Fast debugging with Pry."

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<pry>, ["~> 0.9.12"])
      s.add_runtime_dependency(%q<byebug>, ["~> 2.7"])
      s.add_development_dependency(%q<bundler>, ["~> 1.5"])
      s.add_development_dependency(%q<rake>, ["~> 10.1"])
      s.add_development_dependency(%q<mocha>, ["~> 1.0"])
    else
      s.add_dependency(%q<pry>, ["~> 0.9.12"])
      s.add_dependency(%q<byebug>, ["~> 2.7"])
      s.add_dependency(%q<bundler>, ["~> 1.5"])
      s.add_dependency(%q<rake>, ["~> 10.1"])
      s.add_dependency(%q<mocha>, ["~> 1.0"])
    end
  else
    s.add_dependency(%q<pry>, ["~> 0.9.12"])
    s.add_dependency(%q<byebug>, ["~> 2.7"])
    s.add_dependency(%q<bundler>, ["~> 1.5"])
    s.add_dependency(%q<rake>, ["~> 10.1"])
    s.add_dependency(%q<mocha>, ["~> 1.0"])
  end
end
