echo    "
本脚本可以自动申请并使用tls证书加密保护流量。输入解析的有效域名地址：
"
read    site
echo    "好的，现在要开始安装了。"
sleep   2s
apt     -y    update
apt     -y    install    wget nginx net-tools certbot
wget    -c    https://github.com/XTLS/Xray-install/raw/main/install-release.sh
bash          install-release.sh     install
certbot       certonly     --standalone  -n  --agree-tos  -m  admin@hanhongju.com  -d  $site\
              --pre-hook   "systemctl    stop      nginx"\
              --post-hook  "chmod 777 -R /etc/letsencrypt/
                            cp    -p     /etc/letsencrypt/live/$site/fullchain.pem     /srv/fullchain.pem
                            cp    -p     /etc/letsencrypt/live/$site/privkey.pem       /srv/privkey.pem
                            systemctl    restart   nginx"
echo        '
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
'           >      /etc/sysctl.conf
echo        '
* * * * *          date   >>    /root/crontest
0 1 * * *          apt    -y    update
0 2 * * *          apt    -y    full-upgrade
0 3 * * *          apt    -y    autoremove
0 4 * * *          certbot      renew
'           |      crontab
echo        '
{"inbounds": [{"port": 8964
              ,"protocol": "vmess"
              ,"settings": {"clients": [{"id": "8c38d360-bb8f-11ea-9ffd-c182155e578a"}]}
              ,"streamSettings": {"network": "ws"
                                 ,"wsSettings": {"path": "/world"}
                                 }
             }]
,"outbounds":[{"protocol": "freedom"}]
}
'            >             /usr/local/etc/xray/config.json
echo         '
server{
set $proxy_name pubmed.ncbi.nlm.nih.gov;
resolver 8.8.8.8 8.8.4.4 valid=300s;
listen 80 default_server;
listen [::]:80 default_server;
listen 443 ssl default_server;
listen [::]:443 ssl default_server;
ssl_certificate           /srv/fullchain.pem;
ssl_certificate_key       /srv/privkey.pem;
location /          {
sub_filter   $proxy_name   $host;
sub_filter_once off;
proxy_set_header X-Real-IP $remote_addr;
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
proxy_set_header Referer https://$proxy_name;
proxy_set_header Host $proxy_name;
proxy_pass https://$proxy_name;
proxy_set_header Accept-Encoding "";
}
location /world     {
proxy_pass http://127.0.0.1:8964;
proxy_redirect off;
proxy_http_version 1.1;
proxy_set_header Upgrade $http_upgrade;
proxy_set_header Connection "upgrade";
proxy_set_header Host $host;
}
}
'           >           /etc/nginx/sites-enabled/default
systemctl   enable      xray nginx
systemctl   restart     xray nginx
nginx       -t
xray        -test       -config=/usr/local/etc/xray/config.json
netstat     -plnt




directsetup () {
apt     -y    install    wget
wget    https://raw.githubusercontent.com/hanhongju/proxy/master/xrayserver.sh    -O    setup.sh
bash    setup.sh

}




uninstall () {
systemctl     stop      xray nginx
systemctl     disable   xray nginx
netstat       -plnt

}




# xrayserver安装脚本 @ Debian 10 or Ubuntu 20
#Xray的VMESS协议可配合Netch代理UDP协议的网络游戏数据包，VLESS协议不可以。
