#!/bin/bash
dir=$(cd $(dirname $0) && pwd )
case $1 in
load)
    if [ -n "$2" ]; then
        name="${2}.img"
        docker load -i $dir/img/$name
    else 
        docker load -i $dir/img/services.img
    fi
    ;;
save)
    cd ../script
    if [ -n "$2" ]; then
        temp=`echo $2|sed 's/\//-/g'`  #把  / =>  -
        name="${temp}.img"
        echo "保存镜像为:$name"
        docker save -o $dir/img/$name $2
        else
            for img in $(docker-compose config | awk '{if ($1 == "image:") print $2;}'); do
                temp=`echo $img|sed 's/\//-/g'`  #把  / =>  -
                images="$images $temp"
            done
            echo $images
            docker save -o $dir/img/services.img $images
        fi
    ;;
--help)
    echo "支持的格式  save|load  [镜像名称]"
    ;;      
*)
    echo "不支持的指令参数"
    ;;
esac