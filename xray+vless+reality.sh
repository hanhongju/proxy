apt    -y   update
apt    -y   install     net-tools curl
bash   -c   "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install
systemctl   enable      xray
echo        '
0 1 * * *          apt    -y    update
0 2 * * *          apt    -y    full-upgrade
0 3 * * *          apt    -y    autoremove
'           |      crontab

echo        '
{"inbounds": [{"port": 443
              ,"protocol": "vless"
              ,"settings": {"clients": [{"id": "8c38d360-bb8f-11ea-9ffd-c182155e578a"}]
                           ,"decryption": "none"
                           }
              ,"streamSettings": {"network": "raw"
                                 ,"security": "reality"
                                 ,"realitySettings": {"target": "www.mbusa.com:443"
                                                     ,"serverNames": ["www.mbusa.com"]
                                                     ,"privateKey": "SP2bynVtlwks1cmoF6f9kp-0MnoYq_NizAumOkjx5H4"
                                                     ,"shortIds": [""]
                                                     }
                                 }
             }]
,"outbounds":[{"protocol": "freedom"}]
}
'           >           /usr/local/etc/xray/config.json
systemctl   restart     xray
xray        -test       -config=/usr/local/etc/xray/config.json
netstat     -plnt




uninstall () {
systemctl   disable     xray
systemctl   stop        xray
bash        -c          "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ remove --purge
netstat     -plnt

}




# xray+vless+reality安装脚本 @ Debian 12
# 用户ID: 8c38d360-bb8f-11ea-9ffd-c182155e578a
# SNI: www.mbusa.com
# Publickey: 1psC7ZNJWFAj8zG9mGM1EGibv17mQKoujkLEixNWJyo
# 本脚本无需申请tls证书。借用其他网站的tls证书保护流量。
