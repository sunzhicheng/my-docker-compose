#!/bin/bash
CMD=""
if [ -n "$1" ]; then
    CMD=$1
else
    echo "默认start"
    CMD="start"
fi
echo "运行指令: ${CMD}"
echo "jenkins  端口<8881>"
case $CMD in
init)
    echo "开启服务"
    docker-compose  up -d jenkins
    ;;
start)
    echo "开启服务"
    docker-compose  start jenkins
    ;;
restart)
    echo "重启服务"
    docker-compose  restart jenkins
    ;;
stop)
    echo "停止服务"
    docker-compose  stop jenkins
    ;;
rm)
    echo "删除服务"
    docker-compose  rm jenkins
    ;;
--help)
    echo "支持的格式  init|start|restart|stop|rm"
    ;;  
*)

    echo "不支持的指令参数"
    ;;
esac





