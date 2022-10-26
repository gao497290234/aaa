
# !/bin/bash
echo ====================================================================================================
echo
echo                                       马花藤定制定制脚本      
echo 
echo ====================================================================================================
# check root
#[[ $EUID -ne 0 ]] && echo -e "${red}错误：${plain} 必须使用root用户运行此脚本！\n" && exit 1



options=(搭建L2TP 搭建S5)

red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'

function install_l2tp(){
	sshpass -p "${3}" ssh ${2}@${1} -o StrictHostKeyChecking=no "/etc/init.d/s5 stop&&/etc/init.d/xl2tpd stop" >> /root/log.txt 2>&1 &
	sshpass -p "${3}" ssh ${2}@${1} -o StrictHostKeyChecking=no 'rm -f install_l2tp.sh&&wget http://141.164.59.56/install_l2tp.sh&&chmod 777 install_l2tp.sh&&sh install_l2tp.sh' >> /root/log.txt 2>&1 &
	echo ###################################################
	echo "正在检测${1}残留配置,请稍后..."
	echo ###################################################
	sleep 10
	echo "已清理全部数据,正在为${1}安装l2tp服务，请稍等..."
    	sleep 12
    	sshpass -p "${3}" ssh ${2}@${1} -o StrictHostKeyChecking=no "rm -f /etc/ppp/chap-secrets&&echo > /etc/ppp/chap-secrets '#USERNAME  PROVIDER  PASSWORD  IPADDRESS'" >> /root/log.txt 2>&1 &
	sleep 5
	sshpass -p "${3}" ssh ${2}@${1} -o StrictHostKeyChecking=no "echo >> /etc/ppp/chap-secrets admin '*' ${4} '*' " >> /root/log.txt 2>&1 &
	sleep 3
    	sshpass -p "${3}" ssh ${2}@${1} -o StrictHostKeyChecking=no "/etc/init.d/xl2tpd restart"
	echo ###################################################
	echo "l2tp已安装"
	echo ###################################################
	sleep 1
}
function output_l2tp(){
	cat >> $output_file << EOF
	${1},admin,${2}
EOF
}
dajian_l2tp(){
for((i=1;i<=$num;i++));  
do 	
	echo "正在为第 $i 台搭建"
	set +e
	address=$(sed -n "$i, 1p" $input_file | awk -F, '{print $1;}')
	username=$(sed -n "$i, 1p" $input_file | awk -F, '{print $2;}')
	passwd=$(sed -n "$i, 1p" $input_file | awk -F, '{print $3;}')
    	uuid=$(cat "/proc/sys/kernel/random/uuid")
	psd=${uuid: 0: 6}
	install_l2tp $address $username $passwd $psd
	output_l2tp $address $psd
done 
}
function install_s5(){
  	sshpass -p "${3}" ssh ${2}@${1} -o StrictHostKeyChecking=no "/etc/init.d/s5 stop&&/etc/init.d/xl2tpd stop" >> /root/log.txt 2>&1 &
	sshpass -p "${3}" ssh ${2}@${1} -o StrictHostKeyChecking=no "echo > /root/port.txt 10001" >> /root/log.txt 2>&1 &
	sleep 2
	sshpass -p "${3}" ssh ${2}@${1} -o StrictHostKeyChecking=no 'rm -f install_s5.sh&&wget http://141.164.59.56/install_s5.sh&&chmod 777 install_s5.sh&&sh install_s5.sh' >> /root/log.txt 2>&1 &
	sleep 5
	echo ####################################################
	echo "s5代理安装完成"
	echo ###################################################
	sleep 1
}
function output_s5(){
	cat >> $output_file << EOF
	${1},10001,admin,123
EOF
	echo ###################################################
	echo "已将搭建的数据写入 $output_file"
	echo ###################################################
	sleep 2
	clear
}
function dj_s5(){
  for((i=1;i<=$num;i++));  
do 	
	echo "正在为第 $i 台搭建s5"
	set +e
	address=$(sed -n "$i, 1p" $input_file | awk -F, '{print $1;}')
	username=$(sed -n "$i, 1p" $input_file | awk -F, '{print $2;}')
	passwd=$(sed -n "$i, 1p" $input_file | awk -F, '{print $3;}')
  	uuid=$(cat "/proc/sys/kernel/random/uuid")
	psd=${uuid: 0: 6}
	b=$RANDOM
	c=$((b + 2))
	if(($c>50000));
	then
        	port=50000
	elif(($c<10000))
	then
        	port=10000
	else
		port=$c
	fi
	install_s5 $address $username $passwd $port
	output_s5 $address
done
}
echo ====================================================================================================
echo
read -p "请输入放置cvs文件的绝对路径: " input_file
echo
echo ====================================================================================================
echo
echo "csv文件的路径为: $input_file(如果不对请Ctrl+C终止脚本!!!)"
echo
echo ====================================================================================================
echo
read -p "请输入输出文件的绝对路径: " output_file
echo
echo ====================================================================================================
echo
echo "输出文件的绝对路径为: $output_file(如果不对请Ctrl+C终止脚本!!!)"
sleep 0.5
clear
echo #####################################################################################################
num=$(cat $input_file | wc -l)
echo "共有  $num  条地址"
echo
echo
echo
echo "请输你需要搭建的选项目"
echo "1 搭建L2TP"
echo "2 搭建S5"
read -p "输入选项:" check_num
if ((check_num==1));
then
	dajian_l2tp
elif((check_num==2));
then
	dj_s5
else
	echo "输入不符合规范 请重新运行脚本"
fi


