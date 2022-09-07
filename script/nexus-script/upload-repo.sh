#!/bin/bash
# author: LinRuChang
# date: 2022-07-27 04:15:00
# desc: nexus上传脚本
# use
# 	第一种：sh enhanceMavenImport.sh -l 本地仓库目录绝对路径  -u nexus账号 -p nexus密码  -r 远程私库的URL地址 
#		sh enhanceMavenImport.sh绝对路径 -l /www/server/maven/repository2 -u admin -p admin123 -r http://192.168.19.107:8082/repository/lrc
#
# 	第二种：将此脚本放入本地仓库目录里面，然后执行即可- 【切记本地仓库目录与脚本的路径关系的是父子关系，非孙子辈等关系】
#       	sh enhanceMavenImport.sh绝对路径  -u nexus账号 -p nexus密码  -r 远程私库的URL地址 


if [[ $1 == 'help' || $1 == '--help'   ]]; then
	echo "用法： sh $(readlink -f $0) -l 本地仓库绝对路径 -u nexus账号 -p nexus密码 -r 远程仓库URL地址 "
	exit 0
fi


while getopts ":l:r:u:p:" opt; do
        case $opt in
                l) LOCAL_REP_DIR="$OPTARG"
                ;;
                r) REPO_URL="$OPTARG"
                ;;
                u) USERNAME="$OPTARG"
                ;;
                p) PASSWORD="$OPTARG"
                ;;
        esac
done

# 如果不传-l本地仓库路径，则以当前脚本所在的目录的本地仓库路径
if [[ -z ${LOCAL_REP_DIR} ]]; then
	#LOCAL_REP_DIR=$(pwd)
	LOCAL_REP_DIR=$(readlink -f $0 | xargs dirname)
fi


echo "================入参============================="
LOCAL_REP_DIR=$( ( echo ${LOCAL_REP_DIR} | grep '.*\(/\)$' &>/dev/null ) &&  echo ${LOCAL_REP_DIR} || echo  ${LOCAL_REP_DIR}'/' )
echo "待上传的本地仓库地址：${LOCAL_REP_DIR}"
echo "Nexus账号：${USERNAME}"
echo "Nexus密码：${PASSWORD}"
REPO_URL=$( ( echo ${REPO_URL} | grep '.*\(/\)$' &>/dev/null ) &&  echo ${REPO_URL} || echo  ${REPO_URL}'/' )
echo "远程仓库URL地址：${REPO_URL}"
echo "============================================="


if [[ ${USERNAME} && ${PASSWORD} && ${REPO_URL} && -d ${LOCAL_REP_DIR} ]]; then
	echo "入参非空校验通过！！！"
else 
	echo "错误：可能Nexus的账号u、密码p、远程仓库地址r信息有缺失，或者本地仓库目录l不存在，请检查"
	echo "用法： sh $(readlink -f $0) -l 本地仓库绝对路径 -u nexus账号 -p nexus密码 -r 远程仓库URL地址 "
	exit 1;
fi


echo -e  "\n================检测远程目录地址网络连通性, 请耐心等待============================="
if [[ $(curl -X PUT -w '%{http_code}' ${REPO_URL} 2>/dev/null) == '401' ]]; then
	echo "远程仓库【${REPO_URL}】访问通"
else
	echo "错误：远程仓库【${REPO_URL}】访问不通, 请检查"
	exit 1;
fi



echo -e "\n================待上传文件列表展示============================="
# 进入本地仓库，开始检索待上传的文件
cd ${LOCAL_REP_DIR}
# 1. 排除脚本本身、以及含archetype-catalog、maven-metadata-deployment、maven-metadata-deployment字符路径的文件
# 2. 最终筛选出的文件剃掉前面的./字符
# 3. 开始一个一个文件调用curl上传

# 特殊字符/添加上转义字符变为  \/
LOCAL_REP_DIR_ESCAPE=$(echo "${LOCAL_REP_DIR}" | sed 's/\//\\\//g')
# 当前目录待上传的文件
findUploadFiles=$(find . -type f -not -path "./$0" -not -name '*.sh'  -not -regex "\(.*archetype-catalog.*\|.*maven-metadata-deployment.*\)\|.*maven-metadata-local.*")
findUploadFilesCount=$(echo "${findUploadFiles}" | sed '/^s*$/d' | wc -l)
if [ ${findUploadFilesCount} -gt 0  ]; then
	#uploadFiles=$(find . -type f -not -path "./$0" -not -name '*.sh'  -not -regex "\(.*archetype-catalog.*\|.*maven-metadata-deployment.*\)\|.*maven-metadata-local.*" | sed "s|^\./||")
	uploadFiles=$( echo -e "${findUploadFiles}" | sed "s|^\./||")
fi


echo   "$( [  ${findUploadFilesCount} -gt 0  ] &&  ( echo  "${uploadFiles}" | sed 's/^/'"${LOCAL_REP_DIR_ESCAPE}"'&/g') ||  echo   ''  )"
echo "文件个数：${findUploadFilesCount}"
if [ ${findUploadFilesCount} -eq 0  ]; then
	echo -e "\n本地仓库无可上传的文件，脚本结束"
	exit 0
fi


while [ true ]; do
	echo -e '\n请检查上述文件路径是否是你需要上传的？【确定上传按y、取消上传按n】'
	read ensureUpload
	if [ $ensureUpload ] && [ $(echo $ensureUpload | tr [a-z] [A-Z]) == "Y" ]; then
		echo -e "\n================已上传文件列表展示============================="
		currentUploadedCount=0
		#echo "${uploadFiles}"  | sed "s|^\./||" | xargs -I '{}' sh -c     'echo 已上传文件： '"${LOCAL_REP_DIR}"'{};echo "========="'
		echo "${uploadFiles}"  | sed "s|^\./||" | xargs -I '{}' sh -c   "curl -u '$USERNAME:$PASSWORD' -X PUT -v -T {} ${REPO_URL}/{} &>/dev/null  ;  echo '已上传文件: ${LOCAL_REP_DIR}{}'"
		echo '本地仓库文件上传结束，脚本结束'
		break
	elif [ $ensureUpload ] && [ $(echo $ensureUpload | tr [a-z] [A-Z]) == "N" ]; then
		echo "取消上传本地仓库文件，脚本结束"
		break
	else
		echo -e "错误：[${ensureUpload}]非法字符，请根据提示输入对应的内容"

	fi
done

