


echo '
{
"inbounds": [{
            "port": 443,
            "protocol": "vless",
            "settings":{
                       "clients": [{"id": "8c38d360-bb8f-11ea-9ffd-c182155e578a"    ,"flow": "xtls-rprx-direct"      ,"level": 0}],
                       "decryption": "none",
                       "fallbacks": [{"www.baidu.com:443"}]
                        },
            "streamSettings": {
                              "network": "tcp",
                              "security": "xtls",
                              "xtlsSettings": {"alpn": ["http/1.1"],
                                               "certificates": [{"certificateFile": "/path/to/fullchain.crt",
                                                                 "keyFile": "/path/to/private.key"}]
                                              }
                               }
              }],
"outbounds": [{"protocol": "freedom"}]
}
'     >     /usr/local/etc/v2ray/config.json
