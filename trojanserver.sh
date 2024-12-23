echo    "
本脚本可以自动申请并使用tls证书加密保护流量。输入解析的有效域名地址：
"
read    site
echo    "好的，现在要开始安装了。"
sleep   5s
apt     -y     update
apt     -y     install     certbot trojan net-tools
certbot        delete      --noninteractive    --cert-name    $site
certbot        certonly    --noninteractive    --domain       $site    --standalone    --agree-tos    --email     admin@hanhongju.com\
               --pre-hook  "systemctl stop trojan"  --post-hook "chmod 777 -R /etc/letsencrypt/; systemctl restart trojan"
echo    '
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
'       >      /etc/sysctl.conf
echo    '
* * * * *      date   >>    /home/crontest
0 1 * * *      apt    -y    update
0 2 * * *      apt    -y    full-upgrade
0 3 * * *      apt    -y    autoremove
0 4 * * *      certbot      renew
'       |      crontab
echo    '
{"run_type": "server"
,"local_addr": "::"
,"local_port": 443
,"remote_addr": "policy.mofcom.gov.cn"
,"remote_port": 80
,"password": ["fengkuang"]
,"ssl": {"cert": "/etc/letsencrypt/live/www.example.com/fullchain.pem"
        ,"key" : "/etc/letsencrypt/live/www.example.com/privkey.pem"
        ,"alpn": ["http/1.1"]
        }
}
'       >                                             /etc/trojan/config.json
sed         -i        "s/www.example.com/$site/g"     /etc/trojan/config.json
systemctl   enable    trojan
systemctl   restart   trojan
nginx       -t
trojan      -t
netstat     -plnt




directsetup () {
apt     -y    install    wget
wget    https://raw.githubusercontent.com/hanhongju/proxy/master/trojanserver.sh    -O    setup.sh
bash    setup.sh

}





# trojan服务器安装脚本 @ Debian 10 or Ubuntu 20
