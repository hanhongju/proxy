# v2rayserver安装脚本 @ Debian 11
echo    "
本脚本可以自动申请并使用tls证书加密保护流量。安装完成后配置：
端口为             443
用户ID为           8c38d360-bb8f-11ea-9ffd-c182155e578a
传输协议为          ws
底层传输安全为      tls
输入解析的有效域名地址：
"
read    site
echo    "好的，现在要开始安装了。"
sleep   5s
#安装软件申请证书
apt           -y   update
apt           -y   install  certbot v2ray net-tools
systemctl     stop          nginx apache2
certbot       certonly      --standalone -n --agree-tos -m 86606682@qq.com -d $site
chmod         -R   777      /etc/letsencrypt/
#修改系统控制文件启用BBR
echo     '
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
'         >       /etc/sysctl.conf
#修改配置，启动，fallbacks 选项是可选的，只能用于 TCP+TLS 传输组合
echo '
{"inbounds": [{"port": 443
              ,"protocol": "vless"
              ,"settings": {"clients": [{"id": "8c38d360-bb8f-11ea-9ffd-c182155e578a"}]
                           ,"decryption": "none"
                           }
              ,"streamSettings": {"network": "ws"
                                 ,"security": "tls"
                                 ,"tlsSettings": {"serverName": "www.example.com"
                                                 ,"certificates": [{"certificateFile": "/etc/letsencrypt/live/www.example.com/fullchain.pem"
                                                                   ,"keyFile":         "/etc/letsencrypt/live/www.example.com/privkey.pem"}]
                                                  }
                                  }
             }]
,"outbounds": [{"protocol": "freedom"}]
}
'                        >                                   /etc/v2ray/config.json
sed         -i           "s/www.example.com/$site/g"         /etc/v2ray/config.json
systemctl   enable       v2ray nginx cron
systemctl   restart      v2ray nginx cron
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




