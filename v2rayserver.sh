echo    "
本脚本可以自动申请并使用tls证书加密保护流量。输入解析的有效域名地址：
"
read    site
echo    "好的，现在要开始安装了。"
sleep   2s
apt     -y    update
apt     -y    install      wget nginx net-tools certbot v2ray
certbot       delete       --noninteractive    --cert-name    $site
certbot       certonly     --noninteractive    --domain       $site    --standalone    --agree-tos    --email     admin@hanhongju.com\
              --pre-hook   "systemctl    stop      nginx"\
              --post-hook  "chmod 777 -R /etc/letsencrypt/
                            mkdir  -p    /srv/v2ray/
                            cp     -p    /etc/letsencrypt/live/$site/fullchain.pem     /srv/v2ray/fullchain.pem
                            cp     -p    /etc/letsencrypt/live/$site/privkey.pem       /srv/v2ray/privkey.pem
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
'            >             /etc/v2ray/config.json
echo         '
server{
set $proxy_name pubmed.ncbi.nlm.nih.gov;
resolver 8.8.8.8 8.8.4.4 valid=300s;
listen 80 default_server;
listen [::]:80 default_server;
listen 443 ssl default_server;
listen [::]:443 ssl default_server;
ssl_certificate           /srv/v2ray/fullchain.pem;
ssl_certificate_key       /srv/v2ray/privkey.pem;
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
systemctl   enable      v2ray nginx
systemctl   restart     v2ray nginx
nginx       -t
v2ray       -test       -config=/etc/v2ray/config.json
netstat     -plnt




directsetup () {
apt     -y    install    wget
wget    https://raw.githubusercontent.com/hanhongju/proxy/master/v2rayserver.sh    -O    setup.sh
bash    setup.sh

}




uninstall () {
systemctl     stop      v2ray nginx
systemctl     disable   v2ray nginx
netstat       -plnt

}




# v2rayserver安装脚本 @ Debian 12 or Ubuntu 24
# v2ray的VMESS协议可配合Netch代理UDP协议的网络游戏数据包，VLESS协议不可以。
