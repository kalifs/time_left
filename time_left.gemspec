# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{time_left}
  s.version = "0.1.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Artur Meisters"]
  s.date = %q{2010-04-29}
  s.description = %q{Print out time that left doing some process}
  s.email = %q{arturs@ithouse.lv}
  s.extra_rdoc_files = ["README.rdoc", "lib/time_left.rb"]
  s.files = ["README.rdoc", "Rakefile", "init.rb", "lib/time_left.rb", "Manifest", "time_left.gemspec"]
  s.homepage = %q{}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Time_left", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{time_left}
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Print out time that left doing some process}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
