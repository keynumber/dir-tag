#!/bin/bash

tagtool_path="~/.dir-tag/tag-tool.sh"

# ------------- version 1 -----------------------
go=go
gm=gm
gl=gl
gd=gd

alias $go='source '$tagtool_path' to'
alias $gm='source '$tagtool_path' mark'
alias $gl='source '$tagtool_path' list'
alias $gd='source '$tagtool_path' del'

complete -o filenames -F CompTagFile $go
complete -o filenames -F CompTagFile $gl
complete -F CompTag $gd


# ------------- version 2 -----------------------
gcat=gcat
gless=gless
gtail=gtail
gvim=gvim

alias $gcat='source '$tagtool_path' cat'
alias $gless='source '$tagtool_path' less'
alias $gtail='source '$tagtool_path' tail'
alias $gvim='source '$tagtool_path' vim'

complete -o filenames -F CompTagFile $gcat
complete -o filenames -F CompTagFile $gless
complete -o filenames -F CompTagFile $gtail
complete -o filenames -F CompTagFile $gvim


# ------------- version 3 -----------------------
gcp=gcp
gdiff=gdiff
gmv=gmv
gpwd=gpwd


alias gcp='source '$tagtool_path' cp'
alias gdiff='source '$tagtool_path' diff'
alias gmv='source '$tagtool_path' mv'
alias gpwd='source '$tagtool_path' pwd'

complete -o filenames -F CompTagFileWithCurDirFile $gcp
complete -o filenames -F CompTagFileWithCurDirFile $gdiff
complete -o filenames -F CompTagFileWithCurDirFile $gmv
complete -o filenames -F CompTagFile $gpwd
