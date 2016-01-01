install:
    source ./install

usage:
    gm [{tag}]     make mark for current dir (default mark is current directory name)
    gl [{tag}]     list tags or list dir with specific tag
    gd {tag}       del specific tag (default mark is current directory name)

    go {tag-path}       go to dir with specific tag

    gvim    {tag-path}          # new added
    gcat    {tag-path}          # new added
    gless   {tag-path}          # new added
    gmore   {tag-path}          # new added
    gtail   {tag-path}          # new added

    gcp     {tag-path}          # new added
    gpwd    {tag-path}          # new added
    gdiff   {tag-path}          # new added
    gmv     {tag-path}          # new added

add:
    tag auto complete and new command
