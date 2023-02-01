# xrayserver安装脚本 @ Debian 10 or Ubuntu 20
echo    "
本脚本可以自动申请并使用tls证书加密保护流量，反代美国国家生物技术信息中心网址进行网站伪装。安装完成后配置：
端口为             443
用户ID为           8c38d360-bb8f-11ea-9ffd-c182155e578a
传输协议为          ws
底层传输安全为      tls
路径为             /world
输入解析的有效域名地址：
"
read    site
echo    "好的，现在要开始安装了。"
sleep   5s
#安装软件申请证书
apt           -y    update
apt           -y    install         wget nginx certbot net-tools
wget          https://github.com/XTLS/Xray-install/raw/main/install-release.sh    -cP     .
bash          install-release.sh    install
systemctl     stop                  nginx apache2
certbot       certonly              --standalone -n --agree-tos -m 86606682@qq.com -d $site
chmod         -R        777         /etc/letsencrypt/
#配置证书自动更新，cron任务须由crontab安装，直接修改配置文件无效
echo    '
* * * * *     date          >>          /home/crontest
0 1 * * *     apt           -y          update
0 2 * * *     apt           -y          full-upgrade
0 3 * * *     apt           -y          autoremove
0 0 1 * *     systemctl     stop        nginx apache2
1 0 1 * *     certbot       renew
2 0 1 * *     chmod         -R   777    /etc/letsencrypt/
3 0 * * *     systemctl     restart     nginx
'       |     crontab
#修改系统控制文件启用BBR
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
server_name www.example.com;
set $proxy_name pubmed.ncbi.nlm.nih.gov;
resolver 8.8.8.8 8.8.4.4 valid=300s;
listen 80;
listen [::]:80;
listen 443 ssl;
listen [::]:443 ssl;
ssl_certificate          /etc/letsencrypt/live/www.example.com/fullchain.pem;
ssl_certificate_key      /etc/letsencrypt/live/www.example.com/privkey.pem;
if  ( $scheme = http )   {return 301 https://$server_name$request_uri;}
location /          {
sub_filter   $proxy_name   $server_name;
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
'                       >                                           /etc/nginx/sites-enabled/xray.conf
sed         -i          "s/www.example.com/$site/g"                 /etc/nginx/sites-enabled/xray.conf
systemctl   enable      xray nginx cron
systemctl   restart     xray nginx cron
nginx       -vt
xray        -test       -config=/usr/local/etc/xray/config.json
crontab     -l
sysctl      -p
netstat     -plnt




directsetup () {
sudo    su
apt     -y    install    wget
wget    https://github.com/hanhongju/proxy/raw/master/xrayserver.sh    -O    setup.sh
bash    setup.sh

}




uninstall () {
sudo          su
systemctl     stop      xray
systemctl     disable   xray
rm            /etc/nginx/sites-enabled/xray.conf
systemctl     restart   nginx
netstat       -plnt

}




