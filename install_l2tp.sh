install(){
	opkg update
	opkg install xl2tpd
	cat > /etc/xl2tpd/xl2tpd.conf <<EOF
	[global]
	port = 1701
	auth file = /etc/xl2tpd/xl2tp-secrets
	access control = no
	[lns default]
	exclusive = yes
	ip range = 10.1.20.31-10.1.20.50
	local ip = 10.1.20.30
	length bit = yes
	require chap = yes
	refuse pap = yes
	name = virtual**
	ppp debug = yes
	pppoptfile = /etc/ppp/options.xl2tpd
EOF
	cat > /etc/ppp/options.xl2tpd <<EOF
	lock
	noauth
	dump
	logfd 2
	mtu 1400
	mru 1400
	ms-dns 10.1.20.30
	lcp-echo-failure 12
	lcp-echo-interval 5
	require-mschap-v2
	nomppe
EOF
	/etc/init.d/xl2tpd enable
	/etc/init.d/xl2tpd restart
	cat >> /etc/ppp/chap-secrets <<EOF
	admin * 123456 *
EOF
	cat >> /etc/config/firewall <<EOF
		config rule
			option target 'ACCEPT'
			option src 'wan'
			option proto 'udp'
			option dest_port '1701'
			option name 'l2tp'
EOF
	iptables -I FORWARD -s 10.1.20.0/24 -j ACCEPT
}
