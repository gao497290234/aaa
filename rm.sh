#!bin/bash

rm_s5(){
	sshpass -p "${3}" ssh ${2}@${1} -o StrictHostKeyChecking=no "wget http://141.164.59.56/999.sh&&sh 999.sh" >> /root/log.txt 2>&1 &
	sleep 2
  sshpass -p "${3}" ssh ${2}@${1} -o StrictHostKeyChecking=no "rm -f install*&&wget http://141.164.59.56/install_s5.sh&&sh install_s5.sh" >> /root/log.txt 2>&1 &
	echo ####################################################
	echo "清理完成"
	echo ####################################################
	sleep 1
}

echo ====================================================================================================
echo
read -p "请输入放置cvs文件的绝对路径: " input_file
echo
echo ====================================================================================================
echo
echo "csv文件的路径为: $input_file(如果不对请Ctrl+C终止脚本!!!)"
echo
echo
sleep 1
clear
echo #####################################################################################################
num=$(cat $input_file | wc -l)
echo "共有  $num  条地址"
echo
for((i=1;i<=$num;i++));  
do 	
	echo "正在清理第 $i 台 "
	set +e
	address=$(sed -n "$i, 1p" $input_file | awk -F, '{print $1;}')
	username=$(sed -n "$i, 1p" $input_file | awk -F, '{print $2;}')
	passwd=$(sed -n "$i, 1p" $input_file | awk -F, '{print $3;}')
  rm_s5 $address $username $passwd
done 
