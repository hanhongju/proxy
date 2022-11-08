# v2rayclient安装脚本 @ Ubuntu 22
site=cloud.aboutnote.live
apt   -y   update
apt   -y   install     wget curl tsocks v2ray net-tools
echo '
server       =  127.0.0.1
server_type  =  5
server_port  =  8080
default_user =  none
default_pass =  none
'           >           /etc/tsocks.conf
echo '
{"inbounds": [{"port": 8080
              ,"protocol": "socks"
              ,"settings": {"auth": "noauth"
                           }
             }]
,"outbounds": [{"protocol": "vless"
               ,"settings": {"vnext": [{"address": "www.example.com"
                                       ,"port": 443
                                       ,"users": [{"id": "8c38d360-bb8f-11ea-9ffd-c182155e578a"
                                                  ,"encryption":"none"
                                                 }]
                                      }]
                            }
              ,"streamSettings": {"network": "ws"
                                 ,"security": "tls"
                                 }
              }]
}
'                     >                                   /etc/v2ray/config.json
sed         -i        "s/www.example.com/$site/g"         /etc/v2ray/config.json
systemctl   enable    v2ray
systemctl   restart   v2ray
v2ray       -test     -config=/etc/v2ray/config.json
netstat     -plnt
curl        -x        socks5://127.0.0.1:8080        google.com
tsocks      wget      https://cn.wordpress.org/latest-zh_CN.tar.gz     -O      testdownloadfile




uninstall () {
sudo          su
apt           -y        remove     v2ray
systemctl     stop      v2ray
systemctl     disable   v2ray
netstat       -plnt

}




