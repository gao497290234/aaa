#!bin/bash
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'
echo ====================================================================================================
read -p "请输入需要搭建服务器的csv文件的绝对路径: " input_file
echo ====================================================================================================
ehco "放置鸡绝对路径为$input_file(如果不对请Ctrl+C终止运行!!!)"
ehco ====================================================================================================
read -p "请输入输入文件的绝对路径: " output_file
ehco ====================================================================================================
ehco "放置输出文件的对路径为$output_file(如果不对请Ctrl+C终止运行!!!)"
for((i=1;i<=$(cat 1.csv | wc -l);i++));  
do 
	set +e
	address=$(sed -n "$i, 1p" $file | awk -F, '{print $1;}')
	username=$(sed -n "$i, 1p" $file | awk -F, '{print $2;}')
	passwd=$(sed -n "$i, 1p" $file | awk -F, '{print $3;}')
	install_l2tp(address,username,passwd)
	output(address)
done 
install_l2tp(a,u,p){
		ehco
		echo -------------------------------
		echo "正在为$a安装l2tp服务，请稍等..."
		echo -------------------------------
		sshpass -p $passwd ssh $username@$address -o StrictHostKeyChecking=no 'wget http://141.164.59.56/install_l2tp.sh' >> /root/log.txt 2>&1 &
		sleep 10
		ehco
		ehco ------------
		ehco "l2tp已部署"
		ehco ------------
}
output(a){
	cat >> $output_file << EOF
	$a,admin,123456
EOF
	ehco 
	echo -------------------
	ehco "以写入$output_file"
	echo -------------------
}
