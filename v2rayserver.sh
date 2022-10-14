# v2rayserver安装脚本 @ Debian 11
echo    "
本脚本可以自动申请并使用tls证书加密保护流量
端口为             443
用户ID为           8c38d360-bb8f-11ea-9ffd-c182155e578a
传输协议为          ws
底层传输安全为      tls
在下一栏输入您解析的有效域名，请输入域名地址：
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
#配置证书自动更新
echo    '
0 1 * * *     root       apt           -y          update
0 2 * * *     root       apt           -y          full-upgrade
0 3 * * *     root       apt           -y          autoremove
0 0 1 * *     root       systemctl     stop        nginx apache2
1 0 1 * *     root       certbot       renew
2 0 1 * *     root       chmod         -R   777    /etc/letsencrypt/
3 0 * * *     root       systemctl     restart     v2ray
'             >>         /etc/crontab
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
cat         /etc/crontab
sysctl      -p
netstat     -plnt




directsetup () {
apt     -y    install    wget
wget    https://github.com/hanhongju/proxy/raw/master/v2rayserver.sh    -O    setup.sh
bash    setup.sh

}




certbotrenew () {
systemctl     stop        nginx apache2
certbot       renew
chmod         -R   777    /etc/letsencrypt/
systemctl     restart     v2ray

}




