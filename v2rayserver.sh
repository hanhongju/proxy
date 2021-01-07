# V2rayserver安装脚本 @ Debian 10 or Ubuntu 20.04
echo    "
本脚本可以自动安装v2ray，自动申请并使用tls证书加密保护v2ray的流量，反代美国国家生物技术信息中心网址进行网站伪装。需要您事先将此VPS的IP地址解析到一个有效域名上。
如果此VPS使用KVM虚拟技术，此脚本自动开启BBR加速。安装完成后v2ray配置:
端口为             443
用户ID为           8c38d360-bb8f-11ea-9ffd-c182155e578a
额外ID为           0
传输协议为         ws
路径为            /world
底层传输安全为     tls
理解并记录下这些信息后请按回车键继续，并在下一栏输入您解析的有效域名。如果域名输入有误请按Ctrl+C终止脚本运行，然后重新运行脚本。
"
read    nothing
echo    "请输入此VPS的IP对应的域名地址："
read    site
echo    "好的，现在要开始安装了。"
sleep   5s



#计时
begin=$(date +%s)
#安装常用软件包：
apt    update
apt    full-upgrade    -y
apt    autoremove      -y
apt    purge           -y         apache2
apt    install         -y         python3-pip curl nginx
#安装Certbot和V2Ray
pip3   install     cryptography --upgrade
pip3   install     certbot
bash   <(curl   -sL    https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh)
#修改系统控制文件启用BBR
echo     '
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
'         >       /etc/sysctl.conf
#修改v2ray配置
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
'     >     /usr/local/etc/v2ray/config.json



#申请SSL证书
service     nginx       stop
certbot     certonly    --standalone    --agree-tos     -n     -d      $site     -m    86606682@qq.com
#配置证书自动更新
echo       '
0 0 1 * *     service   nginx   stop
1 0 1 * *     certbot   renew
2 0 1 * *     service   nginx   start
0 1 * * *     apt   full-upgrade   -y
0 2 * * *     apt   autoremove     -y
'       |     crontab
service       cron        restart
#创建nginx配置文件
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
if ( $scheme = http ){return 301 https://$server_name$request_uri;}
location /         {           #设置反代网站
sub_filter   $proxy_name   $server_name;
sub_filter_once off;
proxy_set_header X-Real-IP $remote_addr;
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
proxy_set_header Referer https://$proxy_name;
proxy_set_header Host $proxy_name;
proxy_pass https://$proxy_name;
proxy_set_header Accept-Encoding "";
}
location /world     {          #设置v2ray转发
proxy_pass http://127.0.0.1:8964;
proxy_redirect off;
proxy_http_version 1.1;
proxy_set_header Upgrade $http_upgrade;
proxy_set_header Connection "upgrade";
proxy_set_header Host $host;
}
}
'         >       /etc/nginx/sites-enabled/$site.conf
sed      -i       ''s/www.example.com/$site/g''               /etc/nginx/sites-enabled/$site.conf



#启动V2Ray和Nginx：
systemctl   enable    v2ray
systemctl   enable    nginx
service     v2ray     restart
service     nginx     restart
#验证配置文件，显示监听端口
v2ray      -test        -config=/usr/local/etc/v2ray/config.json
nginx      -t
sysctl     -p
crontab    -l
ss         -plnt
#如果nginx配置有错误，重置nginx配置文件
if          [[  $(nginx    -t     2>&1 )   =~   successful   ]]
then        echo   "至此，v2ray可正常工作。"
else        echo   "您输入的域名地址可能没有正确解析或者短时间申请了太多的证书，不能正常申请证书，所以nginx不能正常工作。现在所有nginx配置都已被删除。在您确认了域名解析没有问题后再请重新运行本脚本。"
            rm     -rf     /etc/nginx/sites-enabled/*
fi
finish=$(date +%s)
timeconsume=$(( finish - begin ))
echo   "脚本运行时间$timeconsume秒。"
#至此V2Ray可正常工作




