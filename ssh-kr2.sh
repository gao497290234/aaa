#!bin/bash
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'
install_l2tp(){
	echo
	echo -------------------------------
	echo "installing l2tp service for ${1} at this time，please wait..."
	echo -------------------------------
	sshpass -p ${3} ssh ${2}@${1} -o StrictHostKeyChecking=no 'wget http://141.164.59.56/install_l2tp.sh' >> /root/log.txt 2>&1 &
	sleep 10
	echo
	echo ------------
	echo "l2tp installed"
	echo ------------
}
output(){
	echo $output_file
	cat >> $output_file << EOF
	${1},admin,123456
EOF
	echo 
	echo -------------------
	echo "have wrote $output_file"
	echo -------------------
}

echo ====================================================================================================
read -p "please input adb path of flie: " input_file
echo ====================================================================================================
echo "abs path of flie is $input_file(if that is false please input Ctrl+C!!!)"
echo ====================================================================================================
read -p "palesae ouput ads path of flie: " output_file
echo ====================================================================================================
echo "abs path of flie is $output_file(if that is false please input Ctrl+C!!!)"
num=$(cat $input_file | wc -l)
echo "num is $num"
for((i=1;i<=$num;i++));  
do 	
	echo "starti=$i"
	set +e
	address=$(sed -n "$i, 1p" $input_file | awk -F, '{print $1;}')
	username=$(sed -n "$i, 1p" $input_file | awk -F, '{print $2;}')
	passwd=$(sed -n "$i, 1p" $input_file | awk -F, '{print $3;}')
	install_l2tp $address $input_username $passwd
	output $address
done 
