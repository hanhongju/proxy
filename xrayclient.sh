# xrayclient安装脚本 @ Ubuntu 20
site=gcphk.aboutnote.live
#安装软件
apt     -y     update
apt     -y     install     wget curl tsocks net-tools
wget    -c     http://www.hanhongju.com/Xray-install.sh
wget    -c     http://www.hanhongju.com/Xray-linux-64.zip
bash    Xray-install.sh    -l    Xray-linux-64.zip
#写入配置文件
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
'           >                                             /usr/local/etc/xray/config.json
sed         -i        "s/www.example.com/$site/g"         /usr/local/etc/xray/config.json
#启动
systemctl   enable    xray
systemctl   restart   xray
xray        -test     -config=/usr/local/etc/xray/config.json
netstat     -plnt
curl        -x        socks5://127.0.0.1:8080        google.com
tsocks      wget      https://cn.wordpress.org/latest-zh_CN.tar.gz     -O      testdownloadfile




prepareinstallfiles () {
sudo    su
wget    https://github.com/XTLS/Xray-install/raw/main/install-release.sh                  -O      /home/wordpress/Xray-install.sh
wget    https://github.com/XTLS/Xray-core/releases/download/v1.6.3/Xray-linux-64.zip      -O      /home/wordpress/Xray-linux-64.zip

}




uninstall () {
sudo   su
systemctl     stop      xray
systemctl     disable   xray
netstat       -plnt

}




