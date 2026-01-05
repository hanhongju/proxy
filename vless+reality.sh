


apt     -y    update
apt     -y    install     net-tools curl
bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install

echo        '
{"inbounds": [{"port": 443
              ,"protocol": "vless"
              ,"settings": {"clients": [{"id": "8c38d360-bb8f-11ea-9ffd-c182155e578a"
                                        ,"flow": "xtls-rprx-vision"
                                       }]
                           ,"decryption": "none"
                           }
              ,"streamSettings": {"network": "raw"
                                 ,"security": "reality"
                                 ,"realitySettings": {"target": "www.mbusa.com:443"
                                                     ,"serverNames": ["www.mbusa.com"]
                                                     ,"privateKey": "SP2bynVtlwks1cmoF6f9kp-0MnoYq_NizAumOkjx5H4"   # Password: 1psC7ZNJWFAj8zG9mGM1EGibv17mQKoujkLEixNWJyo
                                                     ,"shortIds": [""]
                                                     }
                                                     
                                 }
             }]
,"outbounds":[{"protocol": "freedom"}]
}
'            >            /usr/local/etc/xray/config.json
xray        -test       -config=/usr/local/etc/xray/config.json




systemctl   enable      xray
systemctl   restart     xray
sleep       2s
netstat     -plnt





# v2rayserver安装脚本 @ Debian 11 or Ubuntu 22
# v2ray的VMESS协议可配合Netch代理UDP协议的网络游戏数据包，VLESS协议不可以。该配置可在v2rayN v5客户端运行。可使用Cloudflare 中转流量。
