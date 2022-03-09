az_localtion=(eastasia southeastasia centralus eastus eastus2 westus northcentralus southcentralus northeurope westeurope japanwest japaneast brazilsouth australiaeast australiasoutheast southindia centralindia westindia jioindiawest jioindiacentral canadacentral canadaeast uksouth ukwest westcentralus westus2 koreacentral koreasouth francecentral francesouth australiacentral  australiacentral2 uaecentral  uaenorth  southafricanorth southafricawest switzerlandnorth  switzerlandwest  germanynort  germanywestcentral norwaywest norwayeast brazilsoutheast westus3 swedencentral)
for((a=0;a<${#az_localtion[@]};a++))
do
		set +e
    sleep 5s
        az group create -n ${az_localtion[$a]} -l ${az_localtion[$a]} #> /root/log.txt 2>&1 &
done
		
