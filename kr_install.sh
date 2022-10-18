#!bin/bash
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'
install_l2tp(){
	echo
	echo -------------------------------
	echo "正在位${1}安装l2tp服务，请稍等..."
	echo -------------------------------
	sshpass -p "${3}" ssh ${2}@${1} -o StrictHostKeyChecking=no 'rm -f install_l2tp.sh&&wget http://141.164.59.56/install_l2tp.sh&&chmod 777 install_l2tp.sh&&sh install_l2tp.sh' >> /root/log.txt 2>&1 &
    sleep 20
    sshpass -p "${3}" ssh ${2}@${1} -o StrictHostKeyChecking=no "rm -f /etc/ppp/chap-secrets&&echo > /etc/ppp/chap-secrets '#USERNAME  PROVIDER  PASSWORD  IPADDRESS'" >> /root/log.txt 2>&1 &
    sshpass -p "${3}" ssh ${2}@${1} -o StrictHostKeyChecking=no "echo >> /etc/ppp/chap-secrets admin '*' ${4} '*'" >> /root/log.txt 2>&1 &
    sshpass -p "${3}" ssh ${2}@${1} -o StrictHostKeyChecking=no "/etc/init.d/xl2tpd restart"
	echo
	echo ------------
	echo "l2tp已安装"
	echo ------------
}
output(){
	echo $output_file
	cat >> $output_file << EOF
	${1},admin,${2}
EOF
	echo 
	echo -------------------
	echo "已将搭建的数据写入 $output_file"
	echo -------------------
}

echo ====================================================================================================
read -p "请输入放置cvs文件的绝对路径: " input_file
echo ====================================================================================================
echo "csv文件的路径为: $input_file(如果不对请Ctrl+C终止脚本!!!)"
echo ====================================================================================================
read -p "请输入输出文件的绝对路径: " output_file
echo ====================================================================================================
echo "输出文件的绝对路径为: $output_file(如果不对请Ctrl+C终止脚本!!!)"
num=$(cat $input_file | wc -l)
echo "共有$num条地址"
for((i=1;i<=$num;i++));  
do 	
	echo "正在为$i搭建"
	set +e
	address=$(sed -n "$i, 1p" $input_file | awk -F, '{print $1;}')
	username=$(sed -n "$i, 1p" $input_file | awk -F, '{print $2;}')
	passwd=$(sed -n "$i, 1p" $input_file | awk -F, '{print $3;}')
    	uuid=$(cat "/proc/sys/kernel/random/uuid")
	install_l2tp $address $username $passwd $uuid
	output $address $uuid
done 
