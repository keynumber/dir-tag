#!/bin/bash

tag_file=~/.mark_tags

function _handleTagParameter() {
    for item in $@
    do
        local len=`expr length $item`
        local pos=`expr index $item '/'`
        local extra=`expr substr $item ${pos} ${len}`
        let pos=$pos-1
        local tag=`expr substr $item 1 ${pos}`

        if test $pos -eq -1
        then
            tag=$item
            extra=
        fi

        local real_path=`awk -v key=$tag -F' ' '$1==key{print $2}' ~/.mark_tags`

        if test -z $real_path
        then
            printf "%s " "$item"
        else
            # 防止特殊字符被转义，如item=tag/*，extra=/*，被转义后成了根目录ls的结果了。。。。
            printf "%s%s " "$real_path""$extra"
        fi
    done
}

function _list() {
    if (test 0 -eq $#)
    then
        cat $tag_file
    else
        local full_path=`_handleTagParameter $@`
        ls $full_path
    fi
}


function _to() {
    local param=$1
    if (test -z $param)
    then
        echo 'Usage go mark {tag}'
    else
        # to 支持标签路径
        # path=`awk -v key=$tag -F' ' '$1==key{print $2}' $tag_file`

        local len=`expr length $param`
        local pos=`expr index $param '/'`
        local extra=`expr substr $param ${pos} ${len}`
        local tag=${param%%/*}

        path=`awk -v key=$tag -F' ' '$1==key{print $2}' $tag_file`
        if (test -z $path)
        then
            echo 'mark not exists'
        else
            cd "$path$extra"
        fi
    fi
}


function _mark() {
    local param=($*)
    local cur_dir=`pwd`
    local tag=${param[0]}
    if (test -z $tag)
    then
        tag=`basename $cur_dir`
    fi
    sed -i  '/^'$tag'\t\t\t/d' $tag_file
    printf "%s\t\t\t%s\n" "$tag" "$cur_dir" >> $tag_file
}


function _delete() {
    local param=($*)
    local cur_dir=`pwd`
    local tag=${param[0]}
    if (test -z $tag)
    then
        tag=`basename $cur_dir`
    fi
    sed -i '/^'$tag'\t\t\t/d' $tag_file
}


function _vim () {
    local param=`_handleTagParameter $@`
    # 防止特殊字符被转义，如item=tag/*，extra=/*，被转义后成了根目录ls的结果了。。。。
    eval "vim $param"
}


function _cat() {
    local param=`_handleTagParameter $@`
    eval "cat $param"
}


function _less() {
    local param=`_handleTagParameter $@`
    eval "less $param"
}


function _tail() {
    local param=`_handleTagParameter $@`
    eval "tail $param"
}

function _pwd() {
    local param=`_handleTagParameter $@`
    eval "echo $param"
}

function _diff() {
    local param=`_handleTagParameter $@`
    eval "vimdiff $param"
}

function _cp() {
    local param="`_handleTagParameter $@`"
    eval "cp $param"
}

function _mv() {
    local param=`_handleTagParameter $@`
    eval "mv $param"
}

function main() {
    if (test $# -lt 1)
    then
        printf "Usage: %s [to|del|list|vim|cat|mark|less|tail|pwd|mv|cp|diff]\n" $0
        exit
    fi

    if (test ! -f $tag_file)
    then
        touch $tag_file
    fi

    local len=$#
    local param=($*)
    local command=${param[0]}
    local arglist=${param[@]:1:$len}

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
        "less")
            _less $arglist
            ;;
        "tail")
            _tail $arglist
            ;;
        "pwd")
            _pwd $arglist
            ;;
        "mv")
            _mv $arglist
            ;;
        "cp")
            _cp $arglist
            ;;
        "diff")
            _diff $arglist
            ;;
        *)
            printf "Usage: %s [to|del|list|vim|cat|mark|less|tail|pwd|mv|cp|diff]\n" $0
            ;;
    esac
}


main $@
