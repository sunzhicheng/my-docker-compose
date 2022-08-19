#!/bin/bash
case $1 in
load)
    docker load -i ./img/services.img
    ;;
save)
    cd ../script
    if [ -n "$2" ]; then
        name="${2}.img"
        docker save -o ../backup/img/$name $2
        else
            for img in $(docker-compose config | awk '{if ($1 == "image:") print $2;}'); do
                images="$images $img"
            done
            echo $images
            docker save -o ../backup/img/services.img $images
        fi
    ;;
--help)
    echo "支持的格式  save|load  [镜像名称]"
    ;;      
*)
    echo "不支持的指令参数"
    ;;
esac