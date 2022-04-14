#!/bin/bash
CMD=""
if [ -n "$1" ]; then
    CMD=$1
else
    echo "指令用于进入服务环境"
    echo "缺少参数支持服务有:mysql  redis openresty jenkins"
    exit 1;
fi

case $CMD in
emq)
    docker-compose exec $CMD sh
    ;;    
*)
    docker-compose exec $CMD bash
    ;;
esac






