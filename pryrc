# vim: syntax=ruby ts=2 sw=2 sts=2 sr noet

require 'rubygems'

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
require 'looksee'
require 'pry-coolline'
# require 'pry-byebug' if mri? && modern?
# require 'pry-stack_explorer' if mri? && legacy?
# require 'pry-nav' if jruby? && modern?
# require 'pry-doc'
# require 'pry-docmore'
# require 'pry-rescue'


Pry.config.color = true
Pry.prompt = Pry::SIMPLE_PROMPT
Pry.config.pager = true
Pry.config.history.file = "#{ENV['HOME']}/.irb_history"

# if defined?(PryByebug)
#   Pry.commands.alias_command 'c', 'continue'
#   Pry.commands.alias_command 's', 'step'
#   Pry.commands.alias_command 'n', 'next'
#   Pry.commands.alias_command 'f', 'finish'

#   # Hit Enter to repeat last command
#   Pry::Commands.command(/^$/, 'repeat last command') do
#     _pry_.run_command Pry.history.to_a.last
#   end
# end

# For convenience
require 'pathname'
local_lib_dir = Pathname.new('./lib').realdirpath
if local_lib_dir.directory?
  relative_path = local_lib_dir.relative_path_from Pathname.new(Dir.pwd).parent
  puts %(\e[2m- Local directory "#{relative_path}" found\e[22m)
  puts %(\e[2m- Prepending "#{relative_path}" to $LOAD_PATH\e[22m)
  $LOAD_PATH.unshift local_lib_dir
end
