require "insync/version"
require 'grit'
require 'cli-colorize'

module Insync   
  class Repository
    
    def initialize(path)
      @path = path
      @repo = Grit::Repo.new @path
      @branch = @repo    
    end
    
    def path
      @path
    end
    
    def log
      @branch.log
    end
    
    def remote_log
      @branch.log("origin/master")
    end
    
    def remote_origin_exists?
      return @repo.remotes.any? { |remote| remote.name == "origin/master" }
    end
    
  end
  
  class RepoWatch
    include CLIColorize
    
    def initialize(path)
      @path = path
    end
    
    def watch
      directory_entries = Dir.entries(@path)
      dirs = directory_entries.find_all {|e| File.directory?(full_path_of e) && e =~ /^[^.]+/}
      
      inspect_path(@path)
      
      dirs.each do |dir_name|
        dir = full_path_of dir_name
        inspect_path(dir)
      end
    end
    
    def inspect_path(path)
      begin
        repo = Repository.new path
        if repo.remote_origin_exists?
          local = repo.log
          remote = repo.remote_log
          if local.first.id != remote.first.id && local.count == remote.count
            puts colorize("\n#{path}\n  => Out of sync\n", { :foreground => :red, :config => :bright })
          elsif local.count < remote.count
            puts colorize("\n#{path}\n  => Behind by #{remote.count-local.count} commits\n", { :foreground => :blue, :config => :bright })
          elsif local.count > remote.count
            puts colorize("\n#{path}\n  => Ahead by #{local.count-remote.count} commits\n", { :foreground => :magenta, :config => :bright })
          end
        end
      rescue
        nil
      end
    end
    
    private
    
    def full_path_of(file)
      File.join(@path, file)
    end
    
  end
end
