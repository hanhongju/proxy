# trojan服务器安装脚本 @ Debian 10 or Ubuntu 20
echo    "
本脚本可以自动申请并使用tls证书加密保护流量，反代朝鲜劳动新闻网进行网站伪装。按回车键继续，并在下一栏输入解析的有效域名。
"
read    nothing
echo    "请输入域名地址："
read    site
echo    "好的，现在要开始安装了。"
sleep   5s
#安装软件申请证书
apt           -y   update    
apt           -y   install  certbot trojan
systemctl     stop          nginx apache2
systemctl     disable       nginx apache2
certbot       certonly      --standalone -n --agree-tos -m 86606682@qq.com -d $site
chmod         -R   777      /etc/letsencrypt/
#配置证书自动更新
echo    "
1 0 1 * *     certbot       renew
2 0 1 * *     chmod         -R   777    /etc/letsencrypt/
3 0 * * *     systemctl     restart     trojan
0 4 * * *     apt           -y          update
0 5 * * *     apt           -y          full-upgrade
0 6 * * *     apt           -y          autoremove
"       |     crontab
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
,"password": ["feichengwurao"]
,"ssl": {"cert": "/etc/letsencrypt/live/www.example.com/fullchain.pem"
        ,"key" : "/etc/letsencrypt/live/www.example.com/privkey.pem"
        ,"alpn": ["http/1.1"]
        }
}
'                     >                                   /etc/trojan/config.json
sed         -i        "s/www.example.com/$site/g"         /etc/trojan/config.json
systemctl   enable    trojan cron
systemctl   restart   trojan cron
trojan      -t
sysctl      -p
crontab     -l
ss          -plnt   |   awk 'NR>1 {print $4,$6}'   |   column   -t





