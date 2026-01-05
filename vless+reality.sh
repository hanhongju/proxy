


apt     -y    update
apt     -y    install     net-tools curl
bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install

echo        '
{"inbounds": [{"port": 8964
              ,"protocol": "vless"
              ,"settings": {"clients": [{"id": "8c38d360-bb8f-11ea-9ffd-c182155e578a"}]}
              ,"streamSettings": {"network": "raw"
                                 ,"security": "reality"
                                 ,"realitySettings": {"target": "example.com:443"
                                                     ,"serverNames": ["example.com"]
                                                     ,"privateKey": "SP2bynVtlwks1cmoF6f9kp-0MnoYq_NizAumOkjx5H4"   # Password: 1psC7ZNJWFAj8zG9mGM1EGibv17mQKoujkLEixNWJyo
                                                     ,"shortIds": [""]
                                                     }
                                                     
                                 }
             }]
,"outbounds":[{"protocol": "freedom"}]
}
'            >            /usr/local/etc/xray/config.json



xray       -test       -config=/usr/local/etc/xray/config.json
systemctl   enable      xray
systemctl   restart     xray
