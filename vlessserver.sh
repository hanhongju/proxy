
#计时
begin=$(date +%s)
#安装常用软件包：
apt    update
apt    full-upgrade    -y
apt    autoremove      -y
apt    purge           -y         apache2
apt    install         -y         python3-pip wget curl net-tools policycoreutils
#安装Certbot和V2Ray
pip3   install     cryptography --upgrade
pip3   install     certbot
bash      -c      "$(curl   -sL    https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh)"
#修改系统控制文件启用BBR
echo     '
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
'         >       /etc/sysctl.conf
#修改v2ray配置
echo '
{
"inbounds": [{
            "port": 443,
            "protocol": "vless",
            "settings":{
                       "clients": [{"id": "8c38d360-bb8f-11ea-9ffd-c182155e578a"    ,"flow": "xtls-rprx-direct"      ,"level": 0}],
                       "decryption": "none",
                       "fallbacks": [{"www.baidu.com:443"}]
                        },
            "streamSettings": {
                              "network": "tcp",
                              "security": "xtls",
                              "xtlsSettings": {"alpn": ["http/1.1"],
                                               "certificates": [{"certificateFile": "/home/fullchain.pem",
                                                                 "keyFile":         "/home/privkey.pem"    }]
                                              }
                               }
              }],
"outbounds": [{"protocol": "freedom"}]
}
'     >     /usr/local/etc/v2ray/config.json
#申请SSL证书
service   nginx   stop
certbot   certonly    --standalone    --agree-tos     -n     -d      $site     -m    86606682@qq.com 
cp       /etc/letsencrypt/live/$site/*      /home/
chmod    -Rf     777     /home/
#配置证书每月1日自动更新
echo       "
0 0 1 * *     service       nginx     stop
1 0 1 * *     certbot       renew
2 0 1 * *     cp           /etc/letsencrypt/live/$site/*          /home/
3 0 1 * *     chmod        -Rf        777       /home/
4 0 1 * *     service       trojan    restart
"      |      crontab
service       cron      restart
#启动V2Ray和Nginx：
systemctl   enable    v2ray
systemctl   enable    nginx
service     v2ray     restart
service     nginx     restart
#验证配置文件，显示监听端口
v2ray      -test        -config=/usr/local/etc/v2ray/config.json
sysctl     -p
crontab    -l
netstat    -plnt
#如果nginx配置有错误，重置nginx配置文件
OUTPUT=$(nginx -t 2>&1)
if     [[  "$OUTPUT"   =~   "successful"   ]]
then        echo   "至此，v2ray可正常工作。"
else        echo   "您输入的域名地址可能没有正确解析或者短时间申请了太多的证书，不能正常申请证书，所以nginx不能正常工作。现在所有nginx配置都已被删除。在您确认了域名解析没有问题后再请重新运行本脚本。"
            rm    -rf    /etc/nginx/sites-enabled/*
fi
finish=$(date +%s)
timeconsume=$(( finish - begin ))
echo   "脚本运行时间$timeconsume秒。"
#至此V2Ray可正常工作




