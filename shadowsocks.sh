apt      -y     update
apt      -y     install      net-tools shadowsocks-libev
echo     '
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
'         >       /etc/sysctl.conf
echo '
{"server"       :   ["::0","0.0.0.0"]
,"server_port"  :   10086
,"fast_open"    :   true
,"method"       :   "aes-256-gcm"
,"password"     :   "fengkuang"
,"mode"         :   "tcp_and_udp"
}
'           >            /etc/shadowsocks-libev/config.json
systemctl   enable       shadowsocks-libev
systemctl   restart      shadowsocks-libev
netstat     -plnt




# shadowsocks安装脚本 @ Debian 10 or Ubuntu 20
