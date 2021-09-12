# v2rayserver安装脚本 @ Debian 11
echo    "
本脚本可以自动安装v2ray，自动申请并使用tls证书加密保护v2ray的流量，反代美国国家生物技术信息中心网址进行网站伪装。安装完成后v2ray配置:
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
apt    update
apt    install   -y       nginx certbot v2ray
systemctl     stop        nginx apache2
certbot       certonly    --standalone -n --agree-tos -m 86606682@qq.com -d $site
chmod         -R   777    /etc/letsencrypt/
#配置证书自动更新
echo    "
0 0 1 * *     systemctl     stop        nginx apache2
1 0 1 * *     certbot       renew
2 0 1 * *     chmod         -R   777    /etc/letsencrypt/
3 0 * * *     systemctl     restart     nginx
"       |     crontab
#修改系统控制文件启用BBR
echo     '
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
'         >       /etc/sysctl.conf
#创建nginx站点配置文件
echo '
server{
server_name vmess.example.com;
set $proxy_name pubmed.ncbi.nlm.nih.gov;
resolver 8.8.8.8 8.8.4.4 valid=300s;
listen 80;
listen [::]:80;
listen 443 ssl;
listen [::]:443 ssl;
ssl_certificate          /etc/letsencrypt/live/vmess.example.com/fullchain.pem;
ssl_certificate_key      /etc/letsencrypt/live/vmess.example.com/privkey.pem;
if  ( $scheme = http )   {return 301 https://$server_name$request_uri;}
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
'         >        /etc/nginx/sites-enabled/v2ray.conf
sed      -i        ''s/vmess.example.com/$site/g''             /etc/nginx/sites-enabled/v2ray.conf
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
'     >     /etc/v2ray/config.json
#启动V2Ray和Nginx：
systemctl   enable      v2ray nginx cron
systemctl   restart     v2ray nginx cron
#验证配置文件，显示监听端口
v2ray       -test      -config=/etc/v2ray/config.json
nginx       -t
sysctl      -p
crontab     -l
ss          -plnt   |   awk 'NR>1 {print $4,$6}'   |   column   -t
if          [[  $(nginx    -t     2>&1 )   =~   successful   ]]
then        echo   "至此，v2ray可正常工作。"
else        echo   "您输入的域名地址可能没有正确解析或者短时间申请了太多的证书，不能正常申请证书，所以nginx不能正常工作。"
fi
finish=$(date +%s)
timeconsume=$(( finish - begin ))
echo   "脚本运行时间$timeconsume秒。"
#至此V2Ray可正常工作












