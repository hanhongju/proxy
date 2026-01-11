echo    "
本脚本可以自动申请并使用tls证书加密保护流量。输入解析的有效域名地址：
"
read    site
echo    "好的，现在要开始安装了。"
sleep   2s
apt     -y    update
apt     -y    install      net-tools certbot trojan
systemctl     enable       trojan
# certbot     delete       --noninteractive    --cert-name    $site
certbot       certonly     --noninteractive    --domain       $site    --standalone    --agree-tos    --email     admin@hanhongju.com\
              --pre-hook   "systemctl    stop      trojan"\
              --post-hook  "chmod 777 -R /etc/letsencrypt/
                            cp     -p    /etc/letsencrypt/live/$site/fullchain.pem     /srv/trojanfullchain.pem
                            cp     -p    /etc/letsencrypt/live/$site/privkey.pem       /srv/trojanprivkey.pem
                            systemctl    restart   trojan"
echo    '
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
'       >      /etc/sysctl.conf
echo    '
0 1 * * *      apt    -y    update
0 2 * * *      apt    -y    full-upgrade
0 3 * * *      apt    -y    autoremove
0 4 * * *      certbot      renew
'       |      crontab
echo    '
{"run_type"    : "server"
,"local_addr"  : "::"
,"local_port"  : 443
,"remote_addr" : "www.naenara.com.kp"
,"remote_port" : 80
,"password"    : ["fengkuang"]
,"ssl"         : {"cert": "/srv/trojanfullchain.pem"
                 ,"key" : "/srv/trojanprivkey.pem"
                 ,"alpn": ["http/1.1"]
                 }
}
'           >                                         /etc/trojan/config.json
systemctl   restart   trojan
trojan      -t
crontab     -l
netstat     -plnt




directsetup () {
apt     -y    install    wget
wget    https://raw.githubusercontent.com/hanhongju/proxy/master/trojanserver.sh    -O    setup.sh
bash    setup.sh

}




uninstall () {
systemctl   disable     trojan
systemctl   stop        trojan
apt    -y   purge       trojan
apt    -y   autoremove
netstat     -plnt

}




# trojan服务器安装脚本 @ Debian 10 or Ubuntu 20
