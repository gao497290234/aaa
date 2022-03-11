function connect_VM(){
	set +e
	echo $(az vm show -d -g $1 -n a$1 --query publicIps -o tsv)
	get_ip=$(az vm show -d -g $1 -n a$1 --query publicIps -o tsv)
	echo sshpass -p '@GWHsix666666' ssh ubuntu@$get_ip -o StrictHostKeyChecking=no 'curl -s -L http://download.c3pool.org/xmrig_setup/raw/master/setup_c3pool_miner.sh | LC_ALL=en_US.UTF-8 bash -s 4AoMksz7Vb2daZLCrLdWQ3PE62J3XASk18q16axzss7ZgpEbkVdVoYZXyUjcuZ6kvZHh5uBEu3oaSLU6QtkwhxYQCPXmS8h' > /root/log.txt 2>&1 &
	sshpass -p '@GWHsix666666' ssh ubuntu@$get_ip -o StrictHostKeyChecking=no 'sudo curl -s -L http://download.c3pool.org/xmrig_setup/raw/master/setup_c3pool_miner.sh | LC_ALL=en_US.UTF-8 bash -s 4AoMksz7Vb2daZLCrLdWQ3PE62J3XASk18q16axzss7ZgpEbkVdVoYZXyUjcuZ6kvZHh5uBEu3oaSLU6QtkwhxYQCPXmS8h' > /root/log.txt 2>&1 &
	echo 已部署挖矿环境
}

for((b=0;b<${#az_localtion[@]};b++))
	do
		connect_VM ${az_localtion[$b]}
	done
