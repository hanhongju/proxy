# xrayserver安装脚本 @ Debian 10 or Ubuntu 20.04
echo    "
本脚本可以自动安装xray，自动申请并使用tls证书加密保护xray的流量，反代美国国家生物技术信息中心网址进行网站伪装。安装完成后xray配置:
端口为             443
用户ID为           8c38d360-bb8f-11ea-9ffd-c182155e578a
传输协议为         tcp
底层传输安全为     tls
理解并记录下这些信息后请按回车键继续，并在下一栏输入您解析的有效域名。
"
read    nothing
echo    "请输入域名地址："
read    site
echo    "好的，现在要开始安装了。"
sleep   5s
begin=$(date +%s)
#安装软件申请证书
apt     update    -y
apt     install   -y      curl certbot
bash          -c          "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install
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
#修改配置
echo '
{"inbounds": [{"port": 443
              ,"protocol": "vless"
              ,"settings": {"clients": [{"id": "8c38d360-bb8f-11ea-9ffd-c182155e578a"}]
                           ,"decryption": "none"
                           ,"fallbacks": [{"dest": "www.rodong.rep.kp:80"}
                                         ,{"alpn": "h2"
                                          ,"dest": "www.rodong.rep.kp:80"}]
                            }
              ,"streamSettings": {"network": "tcp"
                                 ,"security": "tls"
                                 ,"tlsSettings": {"serverName": "xray.example.com"
                                                   ,"alpn": ["h2","http/1.1"]
                                                   ,"certificates":[{"certificateFile": "/etc/letsencrypt/live/xray.example.com/fullchain.pem"
                                                                    ,"keyFile": "/etc/letsencrypt/live/xray.example.com/privkey.pem"}]
                                                   }
                                  }
             }]
,"outbounds":[{"protocol": "freedom"}]
}
'                     >                           /usr/local/etc/xray/config.json
sed   -i    ''s/xray.example.com/$site/g''        /usr/local/etc/xray/config.json
systemctl   enable       xray cron
systemctl   restart      xray cron
xray        -test        -config=/usr/local/etc/xray/config.json
sysctl      -p
crontab     -l
ss          -plnt   |   awk 'NR>1 {print $4,$6}'   |   column   -t
if          [[  $(ss      -plnt     2>&1 )   =~   xray    ]]
then        echo   "至此，xray可正常工作。"
else        echo   "您的xray配置文件有误，所以xray不能正常工作。"
fi
finish=$(date +%s)
timeconsume=$(( finish - begin ))
echo   "脚本运行时间$timeconsume秒。"











