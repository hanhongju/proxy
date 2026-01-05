echo    "
本脚本可以自动申请并使用tls证书加密保护流量。输入解析的有效域名地址：
"
read    site
echo    "好的，现在要开始安装了。"
sleep   2s
apt     -y    update
apt     -y    install      nginx net-tools certbot v2ray
certbot       delete       --noninteractive    --cert-name    $site
certbot       certonly     --noninteractive    --domain       $site    --standalone    --agree-tos    --email     admin@hanhongju.com\
              --pre-hook   "systemctl    stop      nginx"\
              --post-hook  "chmod 777 -R /etc/letsencrypt/
                            cp     -p    /etc/letsencrypt/live/$site/fullchain.pem     /srv/v2rayfullchain.pem
                            cp     -p    /etc/letsencrypt/live/$site/privkey.pem       /srv/v2rayprivkey.pem
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
              ,"protocol": "socks"
              ,"settings": {"auth": "noauth"
                           ,"udp": false
                           ,"userLevel": 10              
                           }
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
if  ( $scheme = http )    {return 301 https://$server_name$request_uri;}
ssl_certificate           /srv/v2rayfullchain.pem;
ssl_certificate_key       /srv/v2rayprivkey.pem;
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
wget    https://raw.githubusercontent.com/hanhongju/proxy/master/v2ray+socks+ws+tls_server.sh    -O    setup.sh
bash    setup.sh

}




# v2ray+socks+ws+tls_server安装脚本 @ Debian 12
# 无法在v2rayN v7中分享链接，无法在v2rayN v5中使用。可使用Cloudflare 中转流量。
