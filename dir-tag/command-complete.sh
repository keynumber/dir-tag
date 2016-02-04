#!/bin/bash

tag_file=~/.mark_tags

##############################################################################
# 在COMPREPLY中填入所有可能补全的标签
# Arguments:
#   默认会输出空格，带参数则不会在后边输出空格
##############################################################################
function CompTag() {
    local tips=($(awk -F'\t' '{print $1}' $tag_file))
    local cur_word=${COMP_WORDS[COMP_CWORD]}
    COMPREPLY=($(compgen -W '${tips[@]}' -- $cur_word))
}

##############################################################################
# 输出标签路径对应的真实路径，如果没有找到对应标签，则原样输出参数
# Arguments:
#   tag_path: 标签路径
##############################################################################
function GetAbsPathFromTagPath() {
    local tag_path=$1
    local tag=${tag_path%%/*}
    local realpath=`awk -F' ' -v key=$tag 'key==$1{print $2}' ${tag_file}`

    # 路径中不包含"/", 则suffix为空
    local suffix='/'${tag_path#*/}
    if [[ ${suffix} == '/'${tag_path} ]]; then
        suffix=
    fi

    if [[ -z ${realpath} ]]; then
        echo ${1}
    else
        echo ${realpath}${suffix}
    fi
}

##############################################################################
# 输出标签路径前缀中，所有可能的完整的标签路径（同样支持非标签路径，即真实路径）
# 如果标签名和当前目录中某个目录或文件重名，优先选择标签路径
# Arguments:
#   tag_path: 标签路径(必须以标签+"/"开头)
##############################################################################
function GetFileTipsFromTagPath() {
    local cur_word=$1

    local full_path=`GetAbsPathFromTagPath $cur_word`

    # 结尾添加"a"，目的是为了当标签路径本身以"/"结尾，dirname命令能正确获取标签路径
    # 如果tag_base就是标签，前缀则为空
    local tag_base=`dirname ${cur_word}a`
    # '/' 这个串的basename和dirname值相同，结果还都是：'/'，因此不用加'/'
    if [[ ${tag_base} != '/' ]]; then
        tag_base="${tag_base}/"
    fi

    local ls_option="-Lpd"
    # ls 添加 -a 选项，支持隐藏文件提示
    # local tips=($(ls -a --color=no $full_path))
    # -A 选项不会输出 . 和 ..
    # -L 选项对于符号链接，使用指向文件信息展示，这样可以将指向目录的链接展示为"name/"
    # -p 对于目录，在末尾添加"/"
    # -d 只显示当前文件，不显示子目录
    #   使用ls *得到补全所有的提示，使用-d选项，否则ls会得到子目录内容

    # ls -d选项会导致输出全路径，需要替换（。。。。目前没有发现更好的办法）
    local tips=(`ls ${ls_option} --color=no $full_path* 2> /dev/null| sed 's#.*/\([^$]\)#\1#g'`)
    local len=${#tips[@]}
    for ((i=0; i<$len; i++)); do
        tips[i]=${tag_base}${tips[$i]}
    done

    echo ${tips[@]}
}

function CompTagFile() {
    local cur_word=${COMP_WORDS[COMP_CWORD]}
    local arr=($(echo $cur_word | tr '/' ' '))
    local path=`awk -F' ' -v key=${arr[0]} 'key==$1{print $2}' ${tag_file}`

    # 当前词还没有一个完整的标签，则补全标签，否则补全标签路径
    if [[ ${cur_word} == ${cur_word##*/} ]]
    then
        CompTag without_space
        COMPREPLY=(${COMPREPLY[@]/%/\/})
        compopt -o nospace
    else
        local tips=(`GetFileTipsFromTagPath $cur_word`)
        COMPREPLY=($(compgen -W '${tips[@]}' -- $cur_word))

        # 只有一个结果，并且标签路径指向一个目录，不产生空格
        if [[ ${#COMPREPLY[@]} -eq 1  &&  ${COMPREPLY[0]} == */ ]]
        then
            compopt -o nospace
        fi

    fi
}

function CompTagFileWithCurDirFile() {
    local cur_word=${COMP_WORDS[COMP_CWORD]}
    local arr=($(echo $cur_word | tr '/' ' '))
    local path=`awk -F' ' -v key=${arr[0]} 'key==$1{print $2}' ${tag_file}`

    # 当前词还没有一个完整的标签，则补全标签，否则补全标签路径
    if [[ ${cur_word} == ${cur_word##*/} ]]
    then
        CompTag without_space
        COMPREPLY=(${COMPREPLY[@]/%/\/})

        # 添加当前目录的内容提示
        # 此处不需要添加-p选项，complete对于当前目录下目录的会自动追加"/"。。。
        local ls_option="-L"
        cur_dir_tips=(`ls ${ls_option} --color=no 2> /dev/null`)
        cur_dir_tips=($(compgen -W '${cur_dir_tips[@]}' -- $cur_word))

        COMPREPLY=(${COMPREPLY[@]} ${cur_dir_tips[@]})
    else
        local tips=(`GetFileTipsFromTagPath $cur_word`)
        COMPREPLY=($(compgen -W '${tips[@]}' -- $cur_word))
    fi

    # 只有一个结果，并且标签路径指向一个目录，不产生空格
    if [[ ${#COMPREPLY[@]} -eq 1  &&  ${COMPREPLY[0]} == */ ]]
    then
        compopt -o nospace
    fi
}

