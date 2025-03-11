site=gcphk.hanhongju.live
apt     -y     update
apt     -y     install     net-tools curl v2ray
echo '
{"inbounds": [{"port": 7000
              ,"protocol": "socks"
              ,"settings": {"auth": "noauth"
                           }
              ,"sniffing": {"enabled": true
                           ,"destOverride": ["http", "tls"]
                           }
             }]
,"outbounds": [{"protocol": "vmess"
               ,"settings": {"vnext": [{"address": "www.example.com"
                                       ,"port": 443
                                       ,"users": [{"id": "8c38d360-bb8f-11ea-9ffd-c182155e578a"
                                                  ,"encryption": "none"
                                                 }]
                                      }]
                            }
              ,"streamSettings": {"network": "ws"
                                 ,"security": "tls"
                                 ,"wsSettings": {"path": "/world"}
                                 }
              }]
}
'           >                                             /etc/v2ray/config.json
sed         -i        "s/www.example.com/$site/g"         /etc/v2ray/config.json
systemctl   enable    v2ray
systemctl   restart   v2ray
v2ray       -test     -config=/etc/v2ray/config.json
netstat     -plnt
curl        --socks5-hostname    127.0.0.1:7000           \
            --location           --continue-at -          \
            --remote-name        https://download-cdn.resilio.com/2.7.3.1381/Debian/resilio-sync_2.7.3.1381-1_amd64.deb




# v2rayclient安装脚本 @ Debian 11 or Ubuntu 22
