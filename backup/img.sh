#!/bin/bash
case $1 in
load)
    docker load -i ./img/services.img
    ;;
save)
    cd ../script
    for img in $(docker-compose config | awk '{if ($1 == "image:") print $2;}'); do
        images="$images $img"
    done
    echo $images
    docker save -o ../backup/img/services.img $images
    ;;
--help)
    echo "支持的格式  save|load "
    ;;      
*)
    echo "不支持的指令参数"
    ;;
esac