## 0. 这个脚本解决什么问题?
如果你烦透了频繁的,cd之后一个很长的路径,那么dir-tag能帮助到你,dir-tag能给目录打上标签,然后直接通过标签就能方便跳转了
花一分钟看下下边的demo,也许你就发现,工具虽小,但是却明在很大程度上提高你的效率

## 1. insall:
``` shell
source ./install
```

## 2. uninstall:
``` shell
./uninstall
```

## 3. usage:
    先声明几个自定义名词。。。
    标签(tag)：目录标签（使用gm对目录打标的标签）
    标签路径(tag-path)：以标签开头的路径，如给家目录打标签为home，家目录下有bin目录，则 home/bin 为标签路径
    真实路径(dir-path)：linux的真实目录
    命令中可以添加对应命令的参数：如 gl -lF tag-path，gtail tag-path -f

    gm [tag] 对当前目录设置标签，标签名为tag，如果不带参数，则默认使用当前目录名作为标签
    gl [tag] 列出所有标签，如果带tag参数，则列出tag对应的目录内容
    gd [tag] 删除对应的tag，如果不带参数，则默认使用当前目录名作为标签进行删除

    go tag-path 跳转到对应的tag-path

    gvim  tag-path 使用vim对tag-path指向的文件、目录进行操作
    gcat  tag-path 使用cat对tag-path指向的文件、目录进行操作
    gless tag-path 使用less对tag-path指向的文件、目录进行操作
    gmore tag-path 使用more对tag-path指向的文件、目录进行操作
    gtail tag-path 使用less对tag-path指向的文件、目录进行操作
    gpwd  tag-path 显示对标签路径对应的绝对路径

    gcp   tag-path or dir-path 将文件tag-path和dir-path之间复制
    gmv   tag-path or dir-path 将文件tag-path和dir-path之间移动
    gdiff tag-path or dir-path 使用vimdiff对比文件tag-path和dir-path

## 4. example
![gif dir-tag example](https://github.com/keynumber/dir-tag/blob/master/dir-tag.gif)

## 5. notice
if you run 'g\*' command in a dir, and there is a sub dir with the name just the tag
name, a slash('/') will be append to the complete tips automatically ....
