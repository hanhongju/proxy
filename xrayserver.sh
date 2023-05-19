# xrayserver安装脚本 @ Debian 10 or Ubuntu 20

site=wenjie.bio

apt   -y    update
apt   -y    install    wget nginx net-tools certbot python3-pip
pip         install    certbot-dns-cloudflare
wget  -c    https://github.com/XTLS/Xray-install/raw/main/install-release.sh
bash        install-release.sh     install
echo        "dns_cloudflare_api_token = jPOSoygxMtPyzr7I47YO3WWA4WrnmFFRgc0xYZ3l"       >       /home/cloudflare_credentials.ini
certbot     certonly  --agree-tos  --eff-email  -m  86606682@qq.com  --dns-cloudflare  --dns-cloudflare-credentials  /home/cloudflare_credentials.ini  -d  *.$site  --deploy-hook  "chmod -R 777 /etc/letsencrypt/" 
cp          /etc/letsencrypt/live/$site/fullchain.pem     /home/fullchain.pem
cp          /etc/letsencrypt/live/$site/privkey.pem       /home/privkey.pem
echo     '
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
'         >       /etc/sysctl.conf
#修改配置，启动。Xray的VMESS协议可配合Netch代理UDP协议的网络游戏数据包，VLESS协议不可以。
echo '
{"inbounds": [{"port": 8964
              ,"protocol": "vmess"
              ,"settings": {"clients": [{"id": "8c38d360-bb8f-11ea-9ffd-c182155e578a"}]}
              ,"streamSettings": {"network": "ws"
                                 ,"wsSettings": {"path": "/world"}
                                 }
             }]
,"outbounds":[{"protocol": "freedom"}]
}
'     >     /usr/local/etc/xray/config.json
echo '
server{
set $proxy_name pubmed.ncbi.nlm.nih.gov;
resolver 8.8.8.8 8.8.4.4 valid=300s;
listen 80 default_server;
listen [::]:80 default_server;
listen 443 ssl default_server;
listen [::]:443 ssl default_server;
ssl_certificate           /home/fullchain.pem;
ssl_certificate_key       /home/privkey.pem;
if  ( $scheme = http )   {return 301 https://$host$request_uri;}
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
sudo    su
apt     -y    install    wget
wget    https://github.com/hanhongju/proxy/raw/master/xrayserver.sh    -O    setup.sh
bash    setup.sh

}




uninstall () {
sudo          su
systemctl     stop      xray nginx
systemctl     disable   xray nginx
netstat       -plnt

}




