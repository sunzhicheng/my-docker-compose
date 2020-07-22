#!/bin/bash
CMD=""
if [ -n "$1" ]; then
    CMD=$1
else
    echo "缺少参数支持服务有:db  redis openresty jenkins"
    exit 1;
fi
docker-compose exec $CMD bash




