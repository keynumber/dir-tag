#!/bin/bash

tagtool_path="~/.dir-tag/tag-tool.sh"

# command
gg=go
gm=gm
gl=gl
gd=gd
gv=gv
gcat=gcat
gmore=gmore
gless=gless
gtail=gtail
gcp=gcp
gmv=gmv

alias $gg='source '$tagtool_path' to'
alias $gm='source '$tagtool_path' mark'
alias $gl='source '$tagtool_path' list'
alias $gd='source '$tagtool_path' del'

alias $gv='source '$tagtool_path' vim'

alias $gcat='source '$tagtool_path' cat'
alias $gmore='source '$tagtool_path' more'
alias $gless='source '$tagtool_path' less'
alias $gtail='source '$tagtool_path' tail'

#alias gcp='source '$tagtool_path' cp'
#alias gmv='source '$tagtool_path' mv'


complete -F CompTag $gg
complete -F CompTag $gl
complete -F CompTag $gd

complete -o filenames -F CompTagFile $gv

complete -o filenames -F CompTagFile $gcat
complete -o filenames -F CompTagFile $gless
complete -o filenames -F CompTagFile $gmore
complete -o filenames -F CompTagFile $gtail
