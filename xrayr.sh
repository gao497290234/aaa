
# !/bin/bash
echo --------------------------------------------------------------------------------------------------
echo 
echo                                       马花藤定制定制脚本      
echo 
echo --------------------------------------------------------------------------------------------------
# check root
[[ $EUID -ne 0 ]] && echo -e "${red}错误：${plain} 必须使用root用户运行此脚本！\n" && exit 1


# check os
if [[ -f /etc/redhat-release ]]; then
    release="centos"
elif cat /etc/issue | grep -Eqi "debian"; then
    release="debian"
elif cat /etc/issue | grep -Eqi "ubuntu"; then
    release="ubuntu"
elif cat /etc/issue | grep -Eqi "centos|red hat|redhat"; then
    release="centos"
elif cat /proc/version | grep -Eqi "debian"; then
    release="debian"
elif cat /proc/version | grep -Eqi "ubuntu"; then
    release="ubuntu"
elif cat /proc/version | grep -Eqi "centos|red hat|redhat"; then
    release="centos"
else
    echo -e "${red}未检测到系统版本，请联系脚本作者！${plain}\n" && exit 1
fi
options=(对接节点，删除节点 退出脚本)

red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'

function docker_check(){
	docker -v > /dev/null
	if [ $? -eq  0 ]; then
		return 0
	else
		return 1
	fi
}

function docker_install(){
	   echo -e "${yellow}检测运行环境未部署！${plain}"
     echo -e "${green}正在部署运行环境...${plain}"
     #curl -fsSL https://get.docker.com -o get-docker.sh
     #sh get-docker.sh
     if [[ x"${release}" == x"centos" ]]; then
         yum upadte -y
         yum install docker -y
     else
         apt update -y
         apt install docker.io -y
     fi
     systemctl restart docker
     echo -e "${green}环境部署完成${plain}"
     echo 
     echo ------------------------------------------------------------------------------------------------
}

function docking(){
	echo ============================================================================================
	read -p "请输入面板类型(SSpanel,V2board注意大小写)："  type
	echo -----------------------------
	echo "面板类型为:"$type
  echo -----------------------------
  ech0
  read -p "请输入节点类型(Shadowsocks,V2ray,Trojan)："  $nodetype
	echo -----------------------------
	echo "面板地址为:"$nodetype
	echo -----------------------------
	echo
	read -p "请输入面板地址："  URL
	echo -----------------------------
	echo "面板地址为:"$URL
	echo -----------------------------
	echo
	read -p "请输入节点ID： "  ID
	echo -----------------------------
	echo "节点ID为:"$ID
	echo -----------------------------
	echo
	read -p "请输入对接端口："  port
	echo -----------------------------
	echo "面板类型为:"$port
  echo------------------------------
  echo
	read -p "请输入面板密钥："  KEY
	echo -----------------------------
	echo "面板密钥为:"$KEY
	echo -----------------------------
	echo ===============================================================================================
	echo
	read -p "回车确定对接....."
	name="$type-$nodetype-$port"
    echo "$name" >> ssr_port.conf
	docker run -d --name=$name -e PANELTYPE=$type -e NODETYPE=$nodetype -e NODEID=$ID -e WEBURL=$URL -e KEY=$KEY --log-opt max-size=1000m --log-opt max-file=3 -p $port:$port/tcp -p $port:$port/udp --restart=always origined/xrayr:1.0
  }



function delete(){
li=$(wc -l < ssr_port.conf)
check=0
if [[ "$li" -eq "$check" ]]; then
    echo
	echo --------------------------
	echo -e "${green} 节点为空 ${plain}"
	echo -------------------------------------------------------------------------------------------------------
else
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
	echo -------------------------------------------------------------------------------------------------------
	for((a=1;a<=$li;a++)); do
		if [ $a -eq $selected ]; then
     		sed -i "${a}d" ssr_port.conf
     		docker stop ${hint[a]}
     		docker rm -f ${hint[a]}
     		echo -e "${green} 选择的节点已删除 ${plain}"
     		echo -------------------------------------------------------------------------------------------------------
			tj=0
			break
		else
			tj=1
		fi
	done
	if [ $tj==1 ]; then
		echo "请输入正确的要删除的节点"
	fi
fi
}


docker_check
if [ $? -eq 1 ]; then
	docker_install
fi

while true
do
echo  "你要做什么呢:"
for ((i=1;i<=${#options[@]};i++ )); do
    hint="${options[$i-1]}"
    echo -e "${green}${i}${plain}. ${hint}"
done
read -p "输入你想做的选项(默认选择1 ${options[0]}):" selected
[ -z "${selected}" ] && selected="1"
case "${selected}" in
    1) docking
    ;;
    2) delete
    ;;
    3) break
    ;;
    *)
    echo -e "[${red}Error${plain}] 请输入[1-3]的数值"
    ;;
esac
done
