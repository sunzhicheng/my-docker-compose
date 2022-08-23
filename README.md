cd  scrip 目录  
启动服务: ./xbuild.sh  init  服务名称(不写服务名称,默认启动  mysql  openresty  redis)

进入服务: ./cmd.sh 服务名称    (类似 docker exec -ti service bash)

查看服务日志:./log.sh 服务名称  

openrety的  nginx.conf 方在  openresty/conf 的目录下

backup目录：是用于导出导入镜像使用的工具脚本