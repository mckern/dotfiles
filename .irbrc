# frozen_string_literal: true

# vim: syntax=ruby ts=2 sw=2 sts=2 sr noet

require 'rubygems'
require 'pp'
require 'bond'
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

begin
  require 'awesome_print'
  AwesomePrint.irb!
rescue LoadError
  warn 'AwesomePrint not found; not loading AwesomePrint'
end

if defined? IRB
	require 'fancy_irb'
  require 'irb/ext/save-history'
  require 'irbtools/configure'
  require 'irb/completion'

  Irbtools.welcome_message = nil
  Irbtools.start
  FancyIrb.start rocket_mode: false

  IRB.conf[:USE_READLINE] = true
  IRB.conf[:AUTO_INDENT]  = false
  IRB.conf[:SAVE_HISTORY] = 1_000_000
  IRB.conf[:HISTORY_FILE] = File.join(ENV['HOME'], '.irb_history')
  IRB.conf[:PROMPT_MODE]  = :SIMPLE
end

local_lib_dir = Pathname.new('./lib').realdirpath
if local_lib_dir.directory?
  relative_path = local_lib_dir
                  .relative_path_from(Pathname.new(Dir.pwd).parent)

  puts %(\e[2m- Local directory "#{relative_path}" found\e[22m)
  puts %(\e[2m- Prepending "#{relative_path}" to $LOAD_PATH\e[22m)
  $LOAD_PATH.unshift local_lib_dir
end
