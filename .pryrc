# vim: syntax=ruby ts=2 sw=2 sts=2 sr noet
# frozen_string_literal: true

require 'rubygems'
require 'pathname'

def jruby?
  RUBY_ENGINE == 'jruby'
end

def mri?
  RUBY_ENGINE == 'ruby'
end

def legacy?
  Gem::Version.new(RUBY_VERSION) > Gem::Version.new('2.0.0')
end

def modern?
  !legacy?
end

def two_one?
  Gem::Version.new(RUBY_VERSION) <= Gem::Version.new('2.1.0')
end

module UniqueMethodExtension
  def unique_methods
    m = [methods - Object.methods].flatten.sort
    if defined? AwesomePrint
      m.instance_variable_set(:@__awesome_methods__, self)
      return ap m
    end

    m
  end
end

class Object
  prepend UniqueMethodExtension
end

if ENV['DEBUNDLE']
  require 'pry-debundle'
  Pry.debundle! if Pry.respond_to? :debundle!
end

require 'readline'
require 'awesome_print'
require 'bond'
# require 'pry-coolline'
require 'pry-byebug' if mri? && modern?

Pry.config.color = true
Pry.config.prompt = Pry::Prompt[:simple][:value]
Pry.config.pager = true
Pry.config.history.file = "#{ENV['HOME']}/.irb_history"

local_lib_dir = Pathname.new('./lib').realdirpath
if local_lib_dir.directory?
  relative_path = local_lib_dir
                  .relative_path_from(Pathname.new(Dir.pwd).parent)

  puts %(\e[2m- Local directory "#{relative_path}" found\e[22m)
  puts %(\e[2m- Prepending "#{relative_path}" to $LOAD_PATH\e[22m)
  $LOAD_PATH.unshift local_lib_dir
end
