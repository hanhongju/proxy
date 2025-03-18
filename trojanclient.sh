site=alihk.hanhongju.com
apt   -y   install     net-tools curl trojan
echo '
{"run_type"    : "client"
,"local_addr"  : "127.0.0.1"
,"local_port"  : 4000
,"remote_addr" : "www.example.com"
,"remote_port" : 443
,"password"    : ["fengkuang"]
,"ssl"         : {"sni"  : "www.example.com"
                 ,"alpn" : ["http/1.1"]
                 }
}
'           >                                             /etc/trojan/config.json
sed         -i        "s/www.example.com/$site/g"         /etc/trojan/config.json
systemctl   enable    trojan
systemctl   restart   trojan
trojan      -t
netstat     -plnt
curl        --socks5-hostname    127.0.0.1:7000           \
            --location           --continue-at -          \
            --remote-name        https://download-cdn.resilio.com/2.7.3.1381/Debian/resilio-sync_2.7.3.1381-1_amd64.deb




# trojan客户端安装脚本 @ Debian 10 or Ubuntu 20
