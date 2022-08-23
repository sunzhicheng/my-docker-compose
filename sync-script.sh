#!/bin/bash
host=$1
#第二个参数为空的话 就用root作为默认值
user=${2-"root"}   
#第三个参数为空的话  就用22作为默认值
port=${3-"22"}

if [ ! -n "$1" ]; then
    echo "同步的host不能为空"
    exit 1;
fi

echo "同步的host:${host}  用户名:${user}   端口:${port}"
ssh_str=$user@$host:/home/$user/docker/script
rsync -ravz --progress "-e ssh -p ${port}" ./script/*  $ssh_str