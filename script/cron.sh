#!/bin/bash
nowtime=$(date "+%Y-%m-%d %H:%M:%S")
echo "before start... "
/usr/local/bin/docker exec redmine  /usr/src/redmine/git-repo/redmine-sync.sh  #redmine 的定时pull变更
echo "before start...  ${nowtime}"