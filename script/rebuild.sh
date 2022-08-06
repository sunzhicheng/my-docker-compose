#!/bin/bash
service=""
if [ -n "$1" ]; then
    service=$1 && \
    docker-compose  stop $service && \
    docker-compose  rm $service && \
    docker-compose  up -d $service 
    docker-compose  logs -f $service 
else
    echo "缺少服务参数"
fi






