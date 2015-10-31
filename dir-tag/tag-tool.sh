#!/bin/bash

tag_file=~/.mark_tags

function _list() {
    param=($*)
    opt=${param[@]:1:$len}

    if (test -z ${param[0]})
    then
        cat $tag_file
    else
        path=`awk -v key=$1 -F' ' '$1==key{print $2}' $tag_file`
        if (test -z $path)
        then
            echo 'mark not exists'
        else
            ls --color $path $opt
        fi
    fi
}


function _to() {
    param=($*)
    tag=${param[0]}
    if (test -z $tag)
    then
        echo 'Usage go mark {tag}'
    else
        path=`awk -v key=$tag -F' ' '$1==key{print $2}' $tag_file`
        if (test -z $path)
        then
            echo 'mark not exists'
        else
            cd $path
        fi
    fi
}


function _mark() {
    param=($*)
    cur_dir=`pwd`
    tag=${param[0]}
    if (test -z $tag)
    then
        tag=`basename $cur_dir`
    fi
    sed -i  '/^'$tag'\t\t\t/d' $tag_file
    printf "%s\t\t\t%s\n" $tag $cur_dir >> $tag_file
}


function _delete() {
    param=($*)
    cur_dir=`pwd`
    tag=${param[0]}
    if (test -z $tag)
    then
        tag=`basename $cur_dir`
    fi
    sed -i '/^'$tag'\t\t\t/d' $tag_file
}


function _GetAbsPathFromTagPath() {
    local tag_path=$1
    local arr=($(echo $tag_path | tr '/' ' '))
    local tag=${arr[0]}
    local path=`cat  $tag_file | awk -F' ' -v key=$tag 'key==$1{print $2}'`
    local pos=`expr index $tag_path '/'`
    if (test ! $pos -eq 0)
    then
        let pos=$pos-1
        echo $path${tag_path:$pos}
    else
        echo $path
    fi
}


function _vim () {
    param=($*)
    opt=${param[@]:1:$len}
    local full_path=`GetAbsPathFromTagPath ${param[0]}`
    vim $full_path $opt
}


function _cat() {
    param=($*)
    opt=${param[@]:1:$len}
    local full_path=`_GetAbsPathFromTagPath ${param[0]}`
    cat $full_path $opt
}


function _less() {
    param=($*)
    opt=${param[@]:1:$len}
    local full_path=`_GetAbsPathFromTagPath ${param[0]}`
    less $full_path $opt
}


function _more() {
    param=($*)
    opt=${param[@]:1:$len}
    local full_path=`_GetAbsPathFromTagPath ${param[0]}`
    more $full_path $opt
}


function _tail() {
    param=($*)
    opt=${param[@]:1:$len}
    local full_path=`_GetAbsPathFromTagPath ${param[0]}`
    tail $full_path $opt
}


function main() {
    if (test $# -lt 1)
    then
        printf 'Usage: %s [to|mark|list] {tags}\n'  $0
        exit
    fi

    if (test ! -f $tag_file)
    then
        echo 'tag file not exists, create ' $tag_file
        touch $tag_file
    fi

    len=$#
    param=($*)
    command=${param[0]}
    arglist=${param[@]:1:$len}

    case $command in
        "to")
            _to $arglist
            ;;
        "del")
            _delete $arglist
            ;;
        "list")
            _list $arglist
            ;;
        "vim")
            _vim $arglist
            ;;
        "cat")
            _cat $arglist
            ;;
        "mark")
            _mark $arglist
            ;;
        "more")
            _more $arglist
            ;;
        "less")
            _less $arglist
            ;;
        "tail")
            _tail $arglist
            ;;
        *)
            printf 'Usage: %s [to|mark|list] {tags}\n'  $0
            ;;
    esac
}


main $@
