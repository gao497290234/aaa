# !/bin/bash
echo ====================================================================================================
echo
echo                                       马花藤定制定制脚本      
echo 
echo ====================================================================================================
# check root
#[[ $EUID -ne 0 ]] && echo -e "${red}错误：${plain} 必须使用root用户运行此脚本！\n" && exit 1


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

options=(添加 删除 退出)

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
	read -p "请输入对接端口初始值：" startp
	echo -----------------------------
	echo "端口初始值为:"$startp
        echo -----------------------------
        echo
        read -p "请输入对接端口结束值："endp
	echo -----------------------------
	echo "节点类型为:"$endp
	echo -----------------------------
	echo
	echo ===============================================================================================
	echo
	read -p "回车确定创建....."
	for((a=$startp;a<=$endp;a++))do
	name=$a
	echo "$a" >> relay_port.conf
        docker run -d --name $a -e Lport=$a -e Rport=$a -e Rhost=user$[a/10000]-$[a%1000].h2yun.xyz --network host --restart=always origined/ehco:1.0
done

    #for((a=$starp;a<=$endp;a++));do
	#	name=$a
     #   echo "$a" >> relay_port.conf
	#	docker run -d --name $a -e Lport=$a -e Rport=$a -e Rhost=user$a/10000-$a%1000.h2yun.xyz --network host --restart=always origined/ehco:1.0
}



function delete(){
li=$(wc -l < port.conf)
check=0
if [[ "$li" -eq "$check" ]]; then
    echo
	echo --------------------------
	echo -e "${green} 节点为空 ${plain}"
	echo -------------------------------------------------------------------------------------------------------
else
	for line in `cat docking_port.conf`
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
     		sed -i "${a}d" docking_port.conf
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
