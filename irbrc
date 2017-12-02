# vim: syntax=ruby ts=2 sw=2 sts=2 sr noet

require 'rubygems'
require 'pp'

begin
  require 'awesome_print'
  AwesomePrint.irb!
rescue LoadError
  warn 'AwesomePrint not found; not loading AwesomePrint'
end

if defined? IRB
  require 'irb/ext/save-history'
  require 'irbtools'

  IRB.conf[:USE_READLINE] = true
  IRB.conf[:AUTO_INDENT]  = false
  IRB.conf[:SAVE_HISTORY] = 1_000_000
  IRB.conf[:HISTORY_FILE] = File.join(ENV['HOME'], '.irb_history')
  IRB.conf[:PROMPT_MODE]  = :SIMPLE
end
