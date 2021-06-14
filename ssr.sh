#！ /bin/bash
echo --------------------------------------------
echo
echo -----------马化腾定制定制脚本-----------------      
echo
echo --------------------------------------------

#安装docker函数
install_docker(){
	docker version > /dev/null || curl -fsSL get.docker.com | bash
}

#面板对接ssr

get_SSR_url(){
	read -p "请输入面板地址："  URL
	echo -----------------------------
	echo "面板地址为"$URL
	echo -----------------------------
	echo
	read -p "请输入节点ID："  ID
	echo -----------------------------
	echo "节点ID为"$ID
	echo -----------------------------
	echo
	read -p "请输入面板密钥："  KEY
	echo -----------------------------
	echo "面板密钥为"$KEY
	echo -----------------------------
	echo
	read -p "请输入监听端口："  port
	echo -----------------------------
	echo "监听端口为"$port
	echo -----------------------------
	echo
	read -p "回车确定对接....."
	name="SSR:$port"
	docker run -d --name=$name -e NODE_ID=$ID -e API_INTERFACE=modwebapi -e WEBAPI_URL=$URL -e SPEEDTEST=0 -e WEBAPI_TOKEN=$KEY --log-opt max-size=1000m --log-opt max-file=3 -p $port:$port/tcp -p $port:$port/udp --restart=always origined/ssr:latest
}
get_SSR_url