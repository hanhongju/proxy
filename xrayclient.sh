# xrayclient安装脚本 @ Ubuntu 20
site=gcphk.aboutnote.live
apt   -y   update
apt   -y   install     wget curl tsocks net-tools

wget  https://github.com/XTLS/Xray-core/releases/download/v1.6.3/Xray-linux-64.zip

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install v2ray



echo '
server       =  127.0.0.1
server_type  =  5
server_port  =  8080
default_user =  none
default_pass =  none
'            >           /etc/tsocks.conf
echo '
{"inbounds": [{"port": 8080
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
systemctl   enable    xray
systemctl   restart   xray
xray        -test     -config=/etc/v2ray/config.json
netstat     -plnt
curl        -x        socks5://127.0.0.1:8080        google.com
tsocks      wget      https://cn.wordpress.org/latest-zh_CN.tar.gz     -O      testdownloadfile




uninstall () {
apt    -y     remove    xray
systemctl     stop      xray
systemctl     disable   xray
netstat       -plnt

}



