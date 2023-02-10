# trojan服务器安装脚本 @ Debian 10 or Ubuntu 20
echo    "
本脚本可以自动申请并使用tls证书加密保护流量。输入解析的有效域名地址：
"
read    site
echo    "好的，现在要开始安装了。"
sleep   5s
#安装软件申请证书
apt           -y   update
apt           -y   install  certbot trojan net-tools
systemctl     stop          nginx apache2
certbot       certonly      --standalone -n --agree-tos -m 86606682@qq.com -d $site
chmod         -R   777      /etc/letsencrypt/
#修改系统控制文件启用BBR
echo     '
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
'         >       /etc/sysctl.conf
#修改配置，启动
echo '
{"run_type": "server"
,"local_addr": "::"
,"local_port": 443
,"remote_addr": "127.0.0.1"
,"remote_port": 80
,"password": ["fengkuang"]
,"ssl": {"cert": "/etc/letsencrypt/live/www.example.com/fullchain.pem"
        ,"key" : "/etc/letsencrypt/live/www.example.com/privkey.pem"
        ,"alpn": ["http/1.1"]
        }
}
'                     >                                   /etc/trojan/config.json
sed         -i        "s/www.example.com/$site/g"         /etc/trojan/config.json
systemctl   enable    trojan nginx cron
systemctl   restart   trojan nginx cron
trojan      -t
crontab     -l
sysctl      -p
netstat     -plnt




directsetup () {
sudo    su
apt     -y    install    wget
wget    https://github.com/hanhongju/proxy/raw/master/trojanserver.sh    -O    setup.sh
bash    setup.sh

}




updatecert () {
sudo    su
apt     -y    install    wget
wget    https://github.com/hanhongju/proxy/raw/master/updatecert.sh    -O    setup.sh
bash    setup.sh

}




uninstall () {
sudo   su
apt    -y     remove    trojan
systemctl     stop      trojan
systemctl     disable   trojan
netstat       -plnt

}




