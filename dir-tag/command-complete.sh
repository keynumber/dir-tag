#!/bin/bash

tag_file=~/.mark_tags


function CompTag() {
    if (test $COMP_CWORD -eq 1)
    then
        local tips=($(awk -F'\t' '{print $1}' $tag_file))
        local cur=${COMP_WORDS[COMP_CWORD]}
        COMPREPLY=($(compgen -W '${tips[@]}' -- $cur))
    fi
}


function CompTagWithOutSpace() {
    local tips=($(awk -F'\t' '{print $1}' $tag_file))
    local cur=${COMP_WORDS[COMP_CWORD]}
    COMPREPLY=($(compgen -W '${tips[@]}' -- $cur))
    if (test ${#COMPREPLY[@]} -eq 1)
    then
        COMPREPLY[0]=${COMPREPLY[0]}'/'
        COMPREPLY[1]=${COMPREPLY[0]}'/'
    fi
}


function GetAbsPathFromTagPath() {
    local tag_path=$1
    local arr=($(echo $tag_path | tr '/' ' '))
    local tag=${arr[0]}
    local path=`cat $tag_file | awk -F' ' -v key=$tag 'key==$1{print $2}'`
    local pos=`expr index $tag_path '/'`
    if (test ! $pos -eq 0)
    then
        let pos=$pos-1
        echo $path${tag_path:$pos}
    else
        echo $path
    fi
}

function GetTipsFromTagPath() {
    local cur_word=$1
    local full_path=`GetAbsPathFromTagPath $cur_word`
    local tag_base=$cur_word

    # escape this case :
    # test/ test.o test.cpp
    # if (test ! -d $full_path)
    if (test -z `echo $full_path | grep '.*/$'`)
    then
        full_path=`dirname $full_path`'/'
        tag_base=`dirname $cur_word`'/'
    fi



    local tips=($(ls --color=no $full_path))
    local len=${#tips[@]}

    for ((i=0; i<$len; i++))
    do
        local path=$full_path${tips[i]}
        tips[i]=$tag_base${tips[i]}
        if (test -d $path)
        then
            tips[i]=${tips[i]}'/'
        fi
    done
    echo 'tips       ' ${tips[@]}
}

function CompTagFile() {
    local cur_word=${COMP_WORDS[COMP_CWORD]}
    local arr=($(echo $cur_word | tr '/' ' '))
    local path=`cat $tag_file | awk -F' ' -v key=${arr[0]} 'key==$1{print $2}'`


    # get full tag first
    if (test 0 -eq `expr index $cur_word'x' '/'`)
    then
        CompTagWithOutSpace
    else
        local tips=`GetTipsFromTagPath $cur_word`
        COMPREPLY=($(compgen -W '$tips' -- $cur_word))
        if (test ! -z ${COMPREPLY[0]} && test -z ${COMPREPLY[1]})
        then
            local full_path=`GetAbsPathFromTagPath ${COMPREPLY[0]}`
            if (test -d $full_path)
            then
                COMPREPLY[1]=${COMPREPLY[0]}'/'
            fi
        fi
        test
    fi
}
