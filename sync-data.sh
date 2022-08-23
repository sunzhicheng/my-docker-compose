#!/bin/bash
host=$1
#第二个参数为空的话 就用root作为默认值
user=${2-"root"}   
#第三个参数为空的话  就用22作为默认值
port=${3-"22"}
data=$4
if [ ! -n "$4" ]; then
    echo "同步的数据目录不能为空"
    exit 1;
fi

echo "同步的host:${host}  用户名:${user}   端口:${port}"

local_str=./$data/*
data_str=$user@$host:/home/$user/docker/$data

rsync -ravz --progress "-e ssh -p ${port}"  $local_str  $data_str