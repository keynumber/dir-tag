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

function GetFileTipsFromTagPath() {
    local cur_word=$1
    local full_path=`GetAbsPathFromTagPath $cur_word`
    local tag_base=$cur_word

    # 如果当前输入的标签路径不以"/"结尾，取base_path，和真是相对的路径（去掉不全的部分路径）
    if (test -z `echo $full_path | grep '.*/$'`)
    then
        full_path=`dirname $full_path`'/'
        tag_base=`dirname $cur_word`'/'
    fi

    # ls 添加 -a 选项，支持隐藏文件提示
    # local tips=($(ls -a --color=no $full_path))
    # -A 选项不会输出 . 和 ..
    # -L 选项对于符号链接，使用指向文件信息展示，这样可以将指向目录的链接展示为"name/"
    # -p 对于目录，在末尾添加"/"

    # 如果tag path指向父目录，那么提示需要全部信息
    local option="-ALp"
    if [[ ${cur_word##*/} == ".." ]]
    then
        option="-aLp"
    fi

    local tips=($(ls ${option} --color=no $full_path))
    local len=${#tips[@]}
    for ((i=0; i<$len; i++))
    do
        tips[i]=$tag_base${tips[i]}
    done

    echo ${tips[@]}
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
        local tips=(`GetFileTipsFromTagPath $cur_word`)
        COMPREPLY=($(compgen -W '${tips[@]}' -- $cur_word))

        # 只有一个结果，并且标签路径指向一个目录,添加多一个提示，从而不产生空格
        if ([ ${#COMPREPLY[@]} -eq 1 ] && [ ! -z `echo ${COMPREPLY[0]} | grep '.*/$'` ])
        then
            COMPREPLY[1]=${COMPREPLY[0]}'/'
        fi

    fi
}

function GetDirTipsFromTagPath() {
    local cur_word=$1
    local full_path=`GetAbsPathFromTagPath $cur_word`
    local tag_base=$cur_word

    # 如果当前输入的标签路径不以"/"结尾，取base_path，和真是相对的路径（去掉不全的部分路径）
    if (test -z `echo $full_path | grep '.*/$'`)
    then
        full_path=`dirname $full_path`'/'
        tag_base=`dirname $cur_word`'/'
    fi

    # ls 添加 -a 选项，支持隐藏文件提示
    # local tips=($(ls -a --color=no $full_path))
    # -A 选项不会输出 . 和 ..
    # -L 选项对于符号链接，使用指向文件信息展示，这样可以将指向目录的链接展示为"name/"
    # -p 对于目录，在末尾添加"/"

    # 如果tag path指向父目录，那么提示需要全部信息
    local option="-ALp"
    if [[ ${cur_word##*/} == ".." ]]
    then
        option="-aLp"
    fi

    local tips=($(ls ${option} --color=no $full_path | grep "/$"))
    local len=${#tips[@]}
    for ((i=0; i<$len; i++))
    do
        tips[i]=$tag_base${tips[i]}
    done

    echo ${tips[@]}
}

function CompTagDir() {
    local cur_word=${COMP_WORDS[COMP_CWORD]}
    local arr=($(echo $cur_word | tr '/' ' '))
    local path=`cat $tag_file | awk -F' ' -v key=${arr[0]} 'key==$1{print $2}'`


    # get full tag first
    if (test 0 -eq `expr index $cur_word'x' '/'`)
    then
        CompTagWithOutSpace
    else
        local tips=(`GetDirTipsFromTagPath $cur_word`)
        COMPREPLY=($(compgen -W '${tips[@]}' -- $cur_word))

        # 只有一个结果，需要一个提示来阻止输出空格，因为目录下有可能还有目录
        if [ ${#COMPREPLY[@]} -eq 1 ]
        then
            COMPREPLY[1]=${COMPREPLY[0]}'/'
        fi

        # 如果没有待匹配结果，表示当前目录下已经没有目录，添加当前词，使在匹配结果后输出空格
        if [ ${#COMPREPLY[@]} -eq 0 ]
        then
            COMPREPLY[1]=${cur_word}
        fi
    fi
}
