#!/bin/bash
CMD=""
service=""
if [ -n "$1" ]; then
    CMD=$1
else
    echo "默认start"
    CMD="start"
fi
if [ -n "$2" ]; then
    service=$2
else
    echo "默认 db redis openresty"
    service="db redis openresty"
fi

echo "运行指令: ${CMD}"
echo "mysql  端口<3306>"
echo "redis  端口<6379>"
case $CMD in
init)
    echo "开启<${service}>服务"
    docker-compose  up -d $service
    ;;
start)
    echo "开启<${service}>服务"
    docker-compose  start $service
    ;;
stop)
    echo "停止<${service}>服务"
    docker-compose  stop $service
    ;;
rm)
    echo "删除<${service}>服务"
    docker-compose  rm $service
    ;;
restart)
    echo "重启<${service}>服务"
    docker-compose  restart $service
    ;;  
--help)
    echo "支持的格式  init|start|stop|rm|restart  null|db|redis|openresty"
    ;;      
*)
    echo "不支持的指令参数"
    ;;
esac





