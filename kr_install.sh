#!bin/bash
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'
clear_server(){
	sshpass -p "${3}" ssh ${2}@${1} -o StrictHostKeyChecking=no "reboot" >> /root/log.txt 2>&1 &
}
install_l2tp(){
	sshpass -p "${3}" ssh ${2}@${1} -o StrictHostKeyChecking=no 'rm -f install_l2tp.sh&&wget http://141.164.59.56/install_l2tp.sh&&chmod 777 install_l2tp.sh&&sh install_l2tp.sh' >> /root/log.txt 2>&1 &
	echo ###################################################
	echo "正在检测${1}残留配置,请稍后..."
	echo ###################################################
	sleep 10
	echo "已清理全部数据,正在为${1}安装l2tp服务，请稍等..."
    	sleep 10
    	sshpass -p "${3}" ssh ${2}@${1} -o StrictHostKeyChecking=no "rm -f /etc/ppp/chap-secrets&&echo > /etc/ppp/chap-secrets '#USERNAME  PROVIDER  PASSWORD  IPADDRESS'" >> /root/log.txt 2>&1 &
	sleep 2
	sshpass -p "${3}" ssh ${2}@${1} -o StrictHostKeyChecking=no "echo >> /etc/ppp/chap-secrets admin '*' ${4} '*' " >> /root/log.txt 2>&1 &
    	sshpass -p "${3}" ssh ${2}@${1} -o StrictHostKeyChecking=no "/etc/init.d/xl2tpd restart"
	echo ###################################################
	echo "l2tp已安装"
	echo ###################################################
	sleep 2
}
output(){
	cat >> $output_file << EOF
	${1},admin,${2}
EOF
	echo ###################################################
	echo "已将搭建的数据写入 $output_file"
	echo ###################################################
	sleep 2
	clear
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
sleep 2
clear
echo #####################################################################################################
num=$(cat $input_file | wc -l)
echo "共有  $num  条地址"
echo
echo
echo
echo "正在清理磁盘需要教长时间请耐心等待..."
for((j=i;j<=$num;j++))
do	
	ad=$(sed -n "$j, 1p" $input_file | awk -F, '{print $1;}')
	us=$(sed -n "$j, 1p" $input_file | awk -F, '{print $2;}')
	pa=$(sed -n "$j, 1p" $input_file | awk -F, '{print $3;}')
	clear_server $ad $us $pa
	sleep 1
done
if (($j>90))
then
	sleep 1
else	
	declare -i sl=70-$j
	sleep $sl
fi
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
	output $address $psd
done 
