#!/bin/bash
base_dir=/usr/src/redmine/git-repo
nowtime=$(date "+%Y-%m-%d %H:%M:%S")
cd ${base_dir}/my-docker-compose.git && git remote update --prune &&  echo $nowtime > ${base_dir}/sync.log