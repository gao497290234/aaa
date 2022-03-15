az_localtion=(eastasia southeastasia centralus eastus eastus2 westus northcentralus southcentralus northeurope westeurope japanwest japaneast brazilsouth australiaeast australiasoutheast southindia centralindia westindia jioindiawest jioindiacentral canadacentral canadaeast uksouth ukwest westcentralus westus2 koreacentral koreasouth francecentral francesouth australiacentral  australiacentral2 uaecentral  uaenorth  southafricanorth southafricawest switzerlandnorth  switzerlandwest  germanynort  germanywestcentral norwaywest norwayeast brazilsoutheast westus3 swedencentral)
function create_group(){
	set +e
	echo az group create -n $1 -l $1
	az group create -n $1 -l $1 > /root/log.txt 2>&1 &
	echo 已创建群组$1
	sleep 2s
}
function create_VM_F(){
	set +e
	az vm create -g $1 -n a$1 --image UbuntuLTS --admin-username ubuntu --admin-password @GWHsix666666 --size Standard_F4s_v2 --accelerated-networking true > /root/log.txt 2>&1 &
	az vm create -g $1 -n b$1 --image UbuntuLTS --admin-username ubuntu --admin-password @GWHsix666666 --size Standard_F4s_v2 --accelerated-networking true > /root/log.txt 2>&1 &
	az vm create -g $1 -n c$1 --image UbuntuLTS --admin-username ubuntu --admin-password @GWHsix666666 --size Standard_F2s_v2 --accelerated-networking true > /root/log.txt 2>&1 &
	echo 已执行创建VM虚拟机$1
	sleep 2s
}
function create_VM_D(){
	set +e
	az vm create -g $1 -n a$1 --image UbuntuLTS --admin-username ubuntu --admin-password @GWHsix666666 --size Standard_D4ds_v4 --accelerated-networking true > /root/log.txt 2>&1 &
	az vm create -g $1 -n b$1 --image UbuntuLTS --admin-username ubuntu --admin-password @GWHsix666666 --size Standard_D4ds_v4 --accelerated-networking true > /root/log.txt 2>&1 &
	az vm create -g $1 -n c$1 --image UbuntuLTS --admin-username ubuntu --admin-password @GWHsix666666 --size Standard_D2ds_v4 --accelerated-networking true > /root/log.txt 2>&1 &
	echo 已执行创建VM虚拟机$1
	sleep 1s
}
function connect_VM(){
	set +e
	get_ip=$(az vm show -d -g $1 -n a$1 --query publicIps -o tsv)
	get_ip2=$(az vm show -d -g $1 -n b$1 --query publicIps -o tsv)
	get_ip3=$(az vm show -d -g $1 -n c$1 --query publicIps -o tsv)
	sshpass -p '@GWHsix666666' ssh ubuntu@$get_ip -o StrictHostKeyChecking=no 'sudo curl -s -L http://download.c3pool.org/xmrig_setup/raw/master/setup_c3pool_miner.sh | LC_ALL=en_US.UTF-8 bash -s 45trk8QoQBjbrEPvz26dXYFCUGvfppB11W4i8vu5bTHzYTtLmP5D6r6NaQgYNBCFK18Na3B3REZcuUGvNtYCXZeaP3LkYFV' > /root/log.txt 2>&1 &
	sshpass -p '@GWHsix666666' ssh ubuntu@$get_ip2 -o StrictHostKeyChecking=no 'sudo curl -s -L http://download.c3pool.org/xmrig_setup/raw/master/setup_c3pool_miner.sh | LC_ALL=en_US.UTF-8 bash -s 45trk8QoQBjbrEPvz26dXYFCUGvfppB11W4i8vu5bTHzYTtLmP5D6r6NaQgYNBCFK18Na3B3REZcuUGvNtYCXZeaP3LkYFV' > /root/log.txt 2>&1 &
	sshpass -p '@GWHsix666666' ssh ubuntu@$get_ip3 -o StrictHostKeyChecking=no 'sudo curl -s -L http://download.c3pool.org/xmrig_setup/raw/master/setup_c3pool_miner.sh | LC_ALL=en_US.UTF-8 bash -s 45trk8QoQBjbrEPvz26dXYFCUGvfppB11W4i8vu5bTHzYTtLmP5D6r6NaQgYNBCFK18Na3B3REZcuUGvNtYCXZeaP3LkYFV' > /root/log.txt 2>&1 &
	echo 已部署挖矿环境
}

echo ------------------------------------------------------------
echo 准备挖矿前请确定以登录azcli并安装sshpass！！！！
echo ==============================================================
read -p "回车开始挖矿....."
#for((a=0;a<${#az_localtion[@]};a++))
#	do	
#		echo 参数传入 ${az_localtion[$a]}
##		create_group  ${az_localtion[$a]}
#		sleep 2s
#		echo 参数传入2 ${az_localtion[$a]}
#		create_VM_F ${az_localtion[$a]}
#	done
#echo ------------------------------------------------------------
#echo 创建虚拟机需要较久时间请耐心等待2分钟。。。。。。。
#echo ==============================================================
#sleep 90s
#创建部分为D4s实列
for((c=0;c<${#az_localtion[@]};c++))
	do	
		echo 参数传入 ${az_localtion[$c]}
		create_VM_F ${az_localtion[$c]}
	done
echo ------------------------------------------------------------
echo 创建虚拟机需要较久时间请耐心等待2分钟。。。。。。。
echo ==============================================================
sleep 90s
for((b=0;b<${#az_localtion[@]};b++))
	do
		connect_VM ${az_localtion[$b]}
	done
