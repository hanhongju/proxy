echo    "
本脚本可以自动申请并使用tls证书加密保护流量。输入解析的有效域名地址：
"
read    site
echo    "好的，现在要开始安装了。"
sleep   2s
apt     -y    update
apt     -y    install      nginx net-tools certbot v2ray
systemctl     enable       v2ray nginx
# certbot     delete       --noninteractive    --cert-name    $site
certbot       certonly     --noninteractive    --domain       $site    --standalone    --agree-tos    --email     admin@hanhongju.com\
              --pre-hook   "systemctl    stop      nginx"\
              --post-hook  "chmod 777 -R /etc/letsencrypt/
                            cp     -p    /etc/letsencrypt/live/$site/fullchain.pem     /srv/proxyfullchain.pem
                            cp     -p    /etc/letsencrypt/live/$site/privkey.pem       /srv/proxyprivkey.pem
                            systemctl    restart   nginx"
echo        '
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
'           >      /etc/sysctl.conf
echo        '
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
resolver 8.8.8.8;
set $proxy_name pubmed.ncbi.nlm.nih.gov;
listen 80;
listen 443 ssl;
ssl_certificate           /srv/proxyfullchain.pem
ssl_certificate_key       /srv/proxyprivkey.pem
location /          {
proxy_pass https://$proxy_name;
proxy_set_header Host $proxy_name;
proxy_set_header X-Real-IP $remote_addr;
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
proxy_set_header Referer $scheme://$proxy_name;
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
systemctl   restart     v2ray nginx
v2ray       -test       -config=/etc/v2ray/config.json
nginx       -t
crontab     -l
netstat     -plnt




directsetup () {
apt     -y    install    wget
wget    https://raw.githubusercontent.com/hanhongju/proxy/master/v2ray+vmess+ws+tls.sh    -O    setup.sh
bash    setup.sh

}




uninstall () {
systemctl   disable     v2ray nginx
systemctl   stop        v2ray nginx
apt    -y   purge       v2ray nginx
apt    -y   autoremove
netstat     -plnt

}




# v2ray+vmess+ws+tls安装脚本 @ Debian 11 or Ubuntu 22
# v2ray的VMESS协议可配合Netch代理UDP协议的网络游戏数据包，VLESS协议不可以。该配置可在v2rayN v5客户端运行。可使用Cloudflare 中转流量。
