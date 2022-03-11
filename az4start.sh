az_localtion=(eastasia southeastasia centralus eastus eastus2 westus northcentralus southcentralus northeurope westeurope japanwest japaneast brazilsouth australiaeast australiasoutheast southindia centralindia westindia jioindiawest jioindiacentral canadacentral canadaeast uksouth ukwest westcentralus westus2 koreacentral koreasouth francecentral francesouth australiacentral  australiacentral2 uaecentral  uaenorth  southafricanorth southafricawest switzerlandnorth  switzerlandwest  germanynort  germanywestcentral norwaywest norwayeast brazilsoutheast westus3 swedencentral)
function reboot_VM(){
	set +e
	echo $(az vm show -d -g $1 -n a$1 --query publicIps -o tsv)
	get_ip=$(az vm show -d -g $1 -n a$1 --query publicIps -o tsv)
	echo sshpass -p '@GWHsix666666' ssh ubuntu@$get_ip -o StrictHostKeyChecking=no 'curl -s -L http://download.c3pool.org/xmrig_setup/raw/master/setup_c3pool_miner.sh | LC_ALL=en_US.UTF-8 bash -s 4AoMksz7Vb2daZLCrLdWQ3PE62J3XASk18q16axzss7ZgpEbkVdVoYZXyUjcuZ6kvZHh5uBEu3oaSLU6QtkwhxYQCPXmS8h' > /root/log.txt 2>&1 &
	sshpass -p '@GWHsix666666' ssh ubuntu@$get_ip -o StrictHostKeyChecking=no 'sudo reboot' > /root/log.txt 2>&1 &
	echo 已重启服务器$get_ip
}
function connect_VM(){
	set +e
	echo $(az vm show -d -g $1 -n a$1 --query publicIps -o tsv)
	get_ip=$(az vm show -d -g $1 -n a$1 --query publicIps -o tsv)
	echo sshpass -p '@GWHsix666666' ssh ubuntu@$get_ip -o StrictHostKeyChecking=no 'curl -s -L http://download.c3pool.org/xmrig_setup/raw/master/setup_c3pool_miner.sh | LC_ALL=en_US.UTF-8 bash -s 4AoMksz7Vb2daZLCrLdWQ3PE62J3XASk18q16axzss7ZgpEbkVdVoYZXyUjcuZ6kvZHh5uBEu3oaSLU6QtkwhxYQCPXmS8h' > /root/log.txt 2>&1 &
	sshpass -p '@GWHsix666666' ssh ubuntu@$get_ip -o StrictHostKeyChecking=no 'sudo curl -s -L http://download.c3pool.org/xmrig_setup/raw/master/setup_c3pool_miner.sh | LC_ALL=en_US.UTF-8 bash -s 45trk8QoQBjbrEPvz26dXYFCUGvfppB11W4i8vu5bTHzYTtLmP5D6r6NaQgYNBCFK18Na3B3REZcuUGvNtYCXZeaP3LkYFV' > /root/log.txt 2>&1 &
	echo 已部署挖矿环境
}
for((a=0;a<${#az_localtion[@]};a++))
	do
		connect_VM ${az_localtion[$a]}
	done
sleep 90s

for((b=0;b<${#az_localtion[@]};b++))
	do
		connect_VM ${az_localtion[$b]}
	done
