# v2rayserver安装脚本 @ Debian 11
echo    "
本脚本可以自动架设shadowsocks服务器。安装完成后配置：
端口为             10086
传输协议为         tcp
加密方式为         aes-256-gcm
输入解析的有效域名地址：
"
sleep   5s
#安装软件
apt     -y     update
apt     -y     install     v2ray net-tools
#修改系统控制文件启用BBR
echo     '
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
'         >       /etc/sysctl.conf
#修改配置，启动
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
wget    https://github.com/hanhongju/proxy/raw/master/v2rayserver.sh    -O    setup.sh
bash    setup.sh

}




uninstall () {
sudo   su
apt    -y     remove    v2ray
systemctl     stop      v2ray
systemctl     disable   v2ray
netstat       -plnt

}




