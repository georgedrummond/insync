# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "insync/version"

Gem::Specification.new do |s|
  s.name        = "insync"
  s.version     = Insync::VERSION
  s.authors     = ["George Drummond"]
  s.email       = ["george@accountsapp.com"]
  s.homepage    = "http://github.com/georgedrummond/insync"
  s.summary     = %q{A simple tool to let you know which git repositories in a folder are either behind, ahead or out of sync with the origin/master}
  s.description = %q{A simple tool to let you know which git repositories in a folder are either behind, ahead or out of sync with the origin/master}

  s.rubyforge_project = "insync"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_dependency "git"
  s.add_dependency "grit"
  s.add_dependency "cli-colorize"
end
