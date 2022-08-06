#!/bin/bash
case $1 in
import)
    if [ -n "$2" ]; then
        name="./containe/${2}-szc.tar"
        imgname="${2}:szc"
        echo "准备导入:${plugin}"
        docker import $name  $imgname
    else
        echo "缺少容器名称"
        exit 1;
    fi
    ;;
export)
    if [ -n "$2" ]; then
        name="./containe/${2}-szc.tar"
        docker export -o $name $2
     else
        echo "缺少容器名称"
        exit 1;
    fi
    ;;
--help)
    echo "支持的格式  import|export  容器名称"
    ;;      
*)
    echo "不支持的指令参数"
    ;;
esac