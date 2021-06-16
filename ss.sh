# !/bin/bash
echo --------------------------------------------
echo 
echo             马花藤定制定制脚本      
echo 
echo --------------------------------------------
#操作选项数据
options=(对接SSR 对接V2ray 删除SSR端口 删除V2ray端口 退出脚本)

red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'

#检测docker函数
function docker_check(){
	docker -v > /dev/null
	if [ $? -eq  0 ]; then
		return 0
	else
		return 1
	fi
}
#安装docker函数
function docker_install()
{
	#echo -e "${green}检查运行环境......${plain}"
	#echo
	#docker -v > /dev/null
    #if [ $? -eq  0 ]; then
        #echo -e "${green}环境已部署${plain}"
    #else
	   echo -e "${yellow}检测运行环境未部署！${plain}"
    	   echo -e "${green}正在部署运行环境...${plain}"
        curl -fsSL https://get.docker.com -o get-docker.sh
        sh get-docker.sh
        echo -e "${green}环境部署完成${plain}"
        echo 
        echo ----------------------------------------------------------
    #fi
}
#ssr对接函数
get_SSR_url(){
	echo ----------------------------------------------------------
	read -p "请输入面板地址："  URL
	echo -----------------------------
	echo "面板地址为"$URL
	echo -----------------------------
	echo
	read -p "请输入节点ID："  ID
	echo -----------------------------
	echo "节点ID为"$ID
	echo -----------------------------
	echo
	read -p "请输入面板密钥："  KEY
	echo -----------------------------
	echo "面板密钥为"$KEY
	echo -----------------------------
	echo
	read -p "请输入监听端口："  port
	echo -----------------------------
	echo "监听端口为"$port
	echo -----------------------------
	echo
	read -p "回车确定对接....."
	name="SSR-$port"
        echo "$name" >> ssr_port.conf
	docker run -d --name=$name -e NODE_ID=$ID -e API_INTERFACE=modwebapi -e WEBAPI_URL=$URL -e SPEEDTEST=0 -e WEBAPI_TOKEN=$KEY --log-opt max-size=1000m --log-opt max-file=3 -p $port:$port/tcp -p $port:$port/udp --restart=always origined/ssr:latest
}
get_v2ray_url(){
	echo ----------------------------------------------------------------------------------
	read -p "请输入面板地址："  URL
	echo -----------------------------
	echo "面板地址为"$URL
	echo -----------------------------
	echo
	read -p "请输入节点ID："  ID
	echo -----------------------------
	echo "节点ID为"$ID
	echo -----------------------------
	echo
	read -p "请输入面板密钥："  KEY
	echo -----------------------------
	echo "面板密钥为"$KEY
	echo -----------------------------
	echo
	read -p "请输入监听端口："  port
	echo -----------------------------
	echo "监听端口为"$port
	echo -----------------------------
	echo
	read -p "回车确定对接.....ctrl+c取消......"
	name="V2-$port"
	docker run -d --name=$name \
	-e speedtest=0 -e api_port=2333 -e downWithPanel=0 \
	-e node_id=$ID -e sspanel_url="$URL" -e key="$KEY" -e TZ="Asia/Shanghai"  -p $port:$port/tcp -p $port:$port/udp \
	--log-opt max-size=10m --log-opt max-file=5 \
	--restart=always \
	origined/v2ray:0.1
}
#删除ssr
function rm_ssr(){
li=$(wc -l < ssr_port.conf)
check=0
if [[ "$li" -eq "$check" ]]; then
     echo
	echo --------------------------
	echo -e "${green} SSR节点为空 ${plain}"
	echo -------------------------------------------------------------------------------------------------------
else
#echo $li
#for ((i=1;i<=$li;i++ )); do
#    hint="${options[$i-1]}"
#    echo -e "${green}${i}${plain}) ${hint}"
#	echo count
	for line in `cat ssr_port.conf`
	do
    		x=$(($x+1))
    		hint[x]=${line}
    		echo
		echo --------------------------
    		echo -e "${green}${x}${plain}. ${hint[x]}"
    		echo -------------------------------------------------------------------------------------------------------
	done
	read -p "输入你要删除的选项:" selected
	for((a=1;a<=$li;a++)); do
		if [ $a -eq $selected ]; then
     		sed -i "${a}d" ssr_port.conf
     		docker stop ${hint[a]}
     		docker rm -f ${hint[a]}
     		echo
     		echo -e "${green} 选择的节点已删除 ${plain}"
     		echo -------------------------------------------------------------------------------------------------------
			tj=0
			break
		else
			tj=1
		fi
	done
	if [ $tj==1 ]; then
		echo "请输入要删除的端口选项而非端口"
	fi
fi
}
#运行一次后台检测docker已安装？自动安装;跳过。
docker_check
if [ $? -eq 1 ]; then
	docker_install
fi

#用户选项界面
while true
do
echo  "你要做什么呢:"
for ((i=1;i<=${#options[@]};i++ )); do
    hint="${options[$i-1]}"
    echo -e "${green}${i}${plain}) ${hint}"
done
read -p "输入你想做的选项(默认选择1 ${options[0]}):" selected
[ -z "${selected}" ] && selected="1"
case "${selected}" in
    1) get_SSR_url
    ;;
    2) get_v2ray_url
    ;;
    3) rm_ssr
    ;;
    4) echo "执行函数4"
    ;;
    5) break
    ;;
    *)
    echo -e "[${red}Error${plain}] Please only enter a number [1-4]"
    ;;
esac
done
