#!bin/bash
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'
echo ====================================================================================================
read -p "请输入需要搭建服务器的csv文件的绝对路径: " input_file
echo ====================================================================================================
echo "放置鸡绝对路径为$input_file(如果不对请Ctrl+C终止运行!!!)"
echo ====================================================================================================
read -p "请输入输入文件的绝对路径: " output_file
echo ====================================================================================================
echo "放置输出文件的对路径为$output_file(如果不对请Ctrl+C终止运行!!!)"
for((i=1;i<=$(cat $input_file | wc -l);i++));  
do 	
	echo "开始i=$i"
	set +e
	address=$(sed -n "$i, 1p" $file | awk -F, '{print $1;}')
	username=$(sed -n "$i, 1p" $file | awk -F, '{print $2;}')
	passwd=$(sed -n "$i, 1p" $file | awk -F, '{print $3;}')
	install_l2tp $address $username $passwd
	output $address
done 
install_l2tp(){
		echo
		echo -------------------------------
		echo "正在为${1}安装l2tp服务，请稍等..."
		echo -------------------------------
		sshpass -p ${3} ssh ${2}@${1} -o StrictHostKeyChecking=no 'wget http://141.164.59.56/install_l2tp.sh' >> /root/log.txt 2>&1 &
		sleep 10
		echo
		echo ------------
		echo "l2tp已部署"
		echo ------------
}
output(){
	cat >> $output_file << EOF
	${1},admin,123456
EOF
	echo 
	echo -------------------
	echo "以写入$output_file"
	echo -------------------
}
