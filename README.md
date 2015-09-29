# dir-tag
directory tag
install:
    source ./install

usage:
    gm {tag}       make mark for current dir
    gl [{tag}]     list tags or list dir with specific tag
    go {tag}       go to dir with specific tag
    gd {tag}       del specific tag

    # commond below can be execute with option, but option must after tag path
    gvim    {tag-path}          # vim file with tag path
    gcat    {tag-path}          # cat file with tag path
    gless   {tag-path}          # less file with tag path
    gmore   {tag-path}          # more file with tag path
    gtail   {tag-path}          # tail file with tag path
