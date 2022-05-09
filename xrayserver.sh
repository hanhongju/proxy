# xrayserver安装脚本 @ Debian 10 or Ubuntu 20
echo    "
本脚本可以自动安装xray，自动申请并使用tls证书加密保护流量，反代美国国家生物技术信息中心网址进行网站伪装。安装完成后配置:
端口为             443
用户ID为           8c38d360-bb8f-11ea-9ffd-c182155e578a
额外ID为           0
传输协议为         ws
路径为            /world
底层传输安全为     tls
理解并记录下这些信息后请按回车键继续，并在下一栏输入您解析的有效域名。
"
read    nothing
echo    "请输入域名地址："
read    site
echo    "好的，现在要开始安装了。"
sleep   5s
#计时
begin=$(date +%s)
#安装软件申请证书
apt           -y    update
apt           -y    install         wget nginx certbot
wget          -c    https://github.com/XTLS/Xray-install/raw/main/install-release.sh
bash          install-release.sh    install
systemctl     stop                  nginx apache2
certbot       certonly              --standalone -n --agree-tos -m 86606682@qq.com -d $site
chmod         -R    777             /etc/letsencrypt/
#配置证书自动更新
echo    '
0 1 * * *     root       apt           -y          update
0 2 * * *     root       apt           -y          full-upgrade
0 3 * * *     root       apt           -y          autoremove
0 0 1 * *     root       systemctl     stop        nginx apache2
1 0 1 * *     root       certbot       renew
2 0 1 * *     root       chmod         -R   777    /etc/letsencrypt/
3 0 * * *     root       systemctl     restart     nginx
'             >>         /etc/crontab
#修改系统控制文件启用BBR
echo     '
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
'         >       /etc/sysctl.conf
#修改配置，启动
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
xray        -test       -config=/usr/local/etc/xray/config.json
cat         /etc/crontab
nginx       -t
sysctl      -p
ss          -plnt     |    awk 'NR>1 {print $4,$6}'   |   column   -t
if          [[  $(nginx    -t     2>&1 )   =~   successful   ]]
then        echo   "至此，xray可正常工作。"
else        echo   "您输入的域名地址可能没有正确解析或者短时间申请了太多的证书，不能正常申请证书，所以nginx不能正常工作。"
fi
finish=$(date +%s)
timeconsume=$(( finish - begin ))
echo   "脚本运行时间$timeconsume秒。"


directsetup () {
apt  -y install wget
wget -c https://raw.githubusercontent.com/hanhongju/proxy/master/xrayserver.sh
bash    xrayserver.sh
}





