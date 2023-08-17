apt     -y     update
apt     -y     install     v2ray net-tools
echo     '
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
'         >       /etc/sysctl.conf
echo '
{"inbounds": [{"port": 10086
              ,"protocol": "shadowsocks"
              ,"settings": {"method": "aes-256-gcm"
                           ,"password": "fengkuang"
                           }
             }]
,"outbounds": [{"protocol": "freedom"}]
}
'           >            /etc/v2ray/config.json
systemctl   enable       v2ray
systemctl   restart      v2ray
v2ray       -test        -config=/etc/v2ray/config.json
sysctl      -p
netstat     -plnt




directsetup () {
sudo    su
apt     -y    install    wget
wget    https://github.com/hanhongju/proxy/raw/master/ssserver.sh    -O    setup.sh
bash    setup.sh

}




uninstall () {
sudo   su
systemctl     stop      v2ray
systemctl     disable   v2ray
netstat       -plnt

}




# shadowsocks安装脚本 @ Debian 11
