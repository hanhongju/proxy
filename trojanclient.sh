site=gcphktj.hanhongju.com
apt   -y   install     net-tools curl trojan
echo '
{"run_type"    : "client"
,"local_addr"  : "127.0.0.1"
,"local_port"  : 8000
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
curl        -L        --socks5-hostname    127.0.0.1:8000  \
            -O        https://github.com/2dust/v2rayN/releases/download/7.9.3/v2rayN-linux-64.deb




# trojan客户端安装脚本 @ Debian 10 or Ubuntu 20
