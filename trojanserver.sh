# trojan服务器安装脚本 @ Debian 10 or Ubuntu 20
echo    "
本脚本可以自动申请并使用tls证书加密保护流量，反代朝鲜劳动新闻网进行网站伪装。输入解析的有效域名地址：
"
read    site
echo    "好的，现在要开始安装了。"
sleep   5s
#安装软件申请证书
apt           -y   update
apt           -y   install  certbot trojan net-tools
systemctl     stop          nginx apache2
certbot       certonly      --standalone -n --agree-tos -m 86606682@qq.com -d $site
chmod         -R   777      /etc/letsencrypt/
#配置证书自动更新
echo    '
0 1 * * *     root       apt           -y          update
0 2 * * *     root       apt           -y          full-upgrade
0 3 * * *     root       apt           -y          autoremove
0 0 1 * *     root       systemctl     stop        nginx apache2
1 0 1 * *     root       certbot       renew
2 0 1 * *     root       chmod         -R   777    /etc/letsencrypt/
3 0 * * *     root       systemctl     restart     nginx trojan
'             >>         /etc/crontab
#修改系统控制文件启用BBR
echo     '
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
'         >       /etc/sysctl.conf
#修改配置，启动
echo '
{"run_type": "server"
,"local_addr": "::"
,"local_port": 443
,"remote_addr": "www.rodong.rep.kp"
,"remote_port": 80
,"password": ["fengkuang"]
,"ssl": {"cert": "/etc/letsencrypt/live/www.example.com/fullchain.pem"
        ,"key" : "/etc/letsencrypt/live/www.example.com/privkey.pem"
        ,"alpn": ["http/1.1"]
        }
}
'                     >                                   /etc/trojan/config.json
sed         -i        "s/www.example.com/$site/g"         /etc/trojan/config.json
systemctl   enable    trojan nginx cron
systemctl   restart   trojan nginx cron
cat         /etc/crontab
netstat     -plnt
trojan      -t
sysctl      -p




directsetup () {
sudo    su
apt     -y    install    wget
wget    https://github.com/hanhongju/proxy/raw/master/trojanserver.sh    -O    setup.sh
bash    setup.sh

}




