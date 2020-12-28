# XTLS安装脚本 @ Debian 10 or Ubuntu 20.04
echo    "
本脚本可以自动安装xray，自动申请并使用tls证书加密保护xray的流量，反代朝鲜劳动新闻网进行网站伪装。需要您事先将此VPS的IP地址解析到一个有效域名上。
如果此VPS使用KVM虚拟技术，此脚本自动开启BBR加速。安装完成后xray配置:
协议为             VLESS
端口为             443
用户ID为           8c38d360-bb8f-11ea-9ffd-c182155e578a
流控为             xtls-rprx-direct
底层传输安全为      xtls
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
apt    purge           -y         apache2 nginx
apt    install         -y         python3-pip wget curl
#安装Certbot和xray
pip3   install     cryptography --upgrade
pip3   install     certbot
bash   <(curl     -sL     https://raw.githubusercontent.com/XTLS/Xray-install/main/install-release.sh)
#修改系统控制文件启用BBR
echo     '
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
'         >       /etc/sysctl.conf
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
4 0 1 * *     service       xray    restart
"      |      crontab
service       cron      restart
#修改v2ray配置文件
echo '
{"inbounds": [{"port": 443
              ,"protocol": "vless"
              ,"settings":{"clients":   [{"id": "8c38d360-bb8f-11ea-9ffd-c182155e578a"  
                                         ,"flow": "xtls-rprx-direct"
                                        }]
                          ,"fallbacks": [{"dest": "www.rodong.rep.kp:80"}]
                          ,"decryption": "none"
                          }
              ,"streamSettings": {"network": "tcp"
                                 ,"security": "xtls"
                                 ,"xtlsSettings": {"alpn": ["http/1.1"]
                                                  ,"certificates": [{"certificateFile": "/home/fullchain.pem"
                                                                    ,"keyFile":         "/home/privkey.pem"
                                                                   }]
                                                  }
                                 }
             }]
,"outbounds": [{"protocol": "freedom"}]
}
'     >     /usr/local/etc/xray/config.json




#启动xray
systemctl     enable     xray
systemctl     restart    xray
#显示监听端口
sleep       1s
xray       -test        -config=/usr/local/etc/xray/config.json
sysctl     -p
crontab    -l
ss         -plnt
if          [[  $(ss   -plnt  |  grep  -oP  xray )   ]]
then        echo   "至此，xray可正常工作。"
else        echo   "您输入的域名地址可能没有正确解析或者短时间申请了太多的证书，不能正常申请证书，所以v2ray不能正常工作。在您确认了域名解析没有问题后再请重新运行本脚本。"
fi
finish=$(date +%s)
timeconsume=$(( finish - begin ))
echo   "脚本运行时间$timeconsume秒。"
#至此xray可正常工作







