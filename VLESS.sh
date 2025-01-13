echo    "
本脚本可以自动申请并使用tls证书加密保护流量。输入解析的有效域名地址：
"
read    site
echo    "好的，现在要开始安装了。"
sleep   2s
apt     -y    update
apt     -y    install      net-tools certbot v2ray
certbot       delete       --noninteractive    --cert-name    $site
certbot       certonly     --noninteractive    --domain       $site    --standalone    --agree-tos    --email     admin@hanhongju.com\
              --pre-hook   "systemctl    stop      v2ray"\
              --post-hook  "chmod 777 -R /etc/letsencrypt/
                            mkdir  -p    /srv/v2ray/
                            cp     -p    /etc/letsencrypt/live/$site/fullchain.pem     /srv/v2ray/fullchain.pem
                            cp     -p    /etc/letsencrypt/live/$site/privkey.pem       /srv/v2ray/privkey.pem
                            systemctl    restart   v2ray"
echo        '
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
'           >      /etc/sysctl.conf
echo        '
* * * * *          date   >>    /root/crontest
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

{"inbounds": [{"port": 443
              ,"protocol": "vless"
              ,"settings": {"clients": [{"id": "8c38d360-bb8f-11ea-9ffd-c182155e578a"}]
                           ,"decryption": "none"
                           ,"fallbacks": [{"dest": "www.baidu.com:443"}
                                         ,{"path": "/websocket"
                                          ,"dest": 10088
                                          ,"xver": 1
                                          }
                                         ]
                            }
               ,"streamSettings": {"network": "tcp"
                                  ,"security": "tls"
                                  ,"tlsSettings": {"alpn": ["http/1.1"]
                                                  ,"certificates": [{"certificateFile": "/path/to/fullchain.crt"
                                                                    ,"keyFile": "/path/to/private.key"
                                                                    }]
                                                   }
                                  }
                }
              ,{"port": 10088
              ,"listen": "127.0.0.1"
              ,"protocol": "vless"
              ,"settings": {"clients": [{"id": "8c38d360-bb8f-11ea-9ffd-c182155e578a"}]
                           ,"decryption": "none"
                           }
              ,"streamSettings": {"network": "ws"
                                 ,"security": "none"
                                 ,"wsSettings": {"acceptProxyProtocol": true,
                                                 "path": "/websocket"
                                                }
                                }
                 }
               ]
,"outbounds": [{"protocol": "freedom"}]
}





'            >             /etc/v2ray/config.json

systemctl   enable      v2ray
systemctl   restart     v2ray
v2ray       -test       -config=/etc/v2ray/config.json
netstat     -plnt




directsetup () {
apt     -y    install    wget
wget    https://raw.githubusercontent.com/hanhongju/proxy/master/v2rayserver.sh    -O    setup.sh
bash    setup.sh

}





# v2rayserver安装脚本 @ Debian 12 or Ubuntu 24
# v2ray的VMESS协议可配合Netch代理UDP协议的网络游戏数据包，VLESS协议不可以。
