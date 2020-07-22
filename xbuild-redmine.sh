#!/bin/bash
CMD=""
if [ -n "$1" ]; then
    CMD=$1
else
    echo "默认start"
    CMD="start"
fi
echo "运行指令: ${CMD}"
echo "redmine  端口<8882>"
case $CMD in
init)
    echo "开启服务"
    docker-compose  up -d redmine
    ;;
start)
    echo "开启服务"
    docker-compose  start redmine
    ;;
stop)
    echo "停止服务"
    docker-compose  stop redmine
    ;;
rm)
    echo "删除服务"
    docker-compose  rm redmine
    ;;
*)

    echo "不支持的指令参数"
    ;;
esac





