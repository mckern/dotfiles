#!/usr/bin/env bash

# Don't let these litter the landscape because *whatever*
# is being inherited, I probably hate it.
unset VISUAL
unset EDITOR

# My preferred editor is TextMate or Sublime Text, but failing
# that I can make do with a small pile of other editors. The way
# that this works, the last resolved editor gets to be the
# default editor, so from least wanted to move.
command -v vi &>/dev/null && export EDITOR='vi'
command -v gvim &>/dev/null && export EDITOR='gvim'
command -v vim &>/dev/null && export EDITOR='vim'
command -v mvim &>/dev/null && export EDITOR='mvim'
command -v nano &>/dev/null && export EDITOR='nano -w'
command -v mate &>/dev/null && export EDITOR='mate -w'
command -v subl &>/dev/null && export EDITOR='subl -w'
