# trojan客户端安装脚本 @ Debian 10 or Ubuntu 20
site=gcp.aboutnote.live
apt   -y   update
apt   -y   install     wget curl tsocks trojan net-tools
echo '
server       =  127.0.0.1
server_type  =  5
server_port  =  8080
default_user =  none
default_pass =  none
'            >           /etc/tsocks.conf
echo '
{"run_type": "client"
,"local_addr": "127.0.0.1"
,"local_port": 8080
,"remote_addr": "www.example.com"
,"remote_port": 443
,"password": ["fengkuang"]
,"ssl": {"sni": "www.example.com"
        ,"alpn": ["http/1.1"]
        }
}
'           >                                             /etc/trojan/config.json
sed         -i        "s/www.example.com/$site/g"         /etc/trojan/config.json
systemctl   enable    trojan
systemctl   restart   trojan
trojan      -t
netstat     -plnt
curl        -x        socks5://127.0.0.1:8080        google.com
tsocks      wget      https://cn.wordpress.org/latest-zh_CN.tar.gz     -O      testdownloadfile




uninstall () {
sudo          su
apt    -y     remove    trojan
systemctl     stop      trojan
systemctl     disable   trojan
netstat       -plnt

}




