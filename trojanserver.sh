# trojan服务器安装脚本 @ Debian 10 or Ubuntu 20
echo    "
本脚本可以自动申请并使用tls证书加密保护流量。输入解析的有效域名地址：
"
read    site
echo    "好的，现在要开始安装了。"
sleep   5s
#安装软件申请证书
apt    -y     update
apt    -y     install  certbot trojan nginx net-tools
systemctl     stop          nginx apache2
certbot       certonly      --standalone -n --agree-tos -m 86606682@qq.com -d $site
chmod         -R   777      /etc/letsencrypt/
#修改系统控制文件启用BBR
echo     '
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
'         >       /etc/sysctl.conf
#修改配置，启动
echo '
server{
set $proxy_name pubmed.ncbi.nlm.nih.gov;
resolver 8.8.8.8 8.8.4.4 valid=300s;
listen 80;
listen [::]:80;
location /          {
proxy_set_header X-Real-IP $remote_addr;
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
proxy_set_header Referer https://$proxy_name;
proxy_set_header Host $proxy_name;
proxy_pass https://$proxy_name;
proxy_set_header Accept-Encoding "";
}
}
'           >        /etc/nginx/sites-enabled/default
echo '
{"run_type": "server"
,"local_addr": "::"
,"local_port": 443
,"remote_addr": "127.0.0.1"
,"remote_port": 80
,"password": ["fengkuang"]
,"ssl": {"cert": "/etc/letsencrypt/live/www.example.com/fullchain.pem"
        ,"key" : "/etc/letsencrypt/live/www.example.com/privkey.pem"
        ,"alpn": ["http/1.1"]
        }
}
'           >                                             /etc/trojan/config.json
sed         -i        "s/www.example.com/$site/g"         /etc/trojan/config.json
systemctl   enable    trojan nginx cron
systemctl   restart   trojan nginx cron
nginx       -vt
trojan      -t
sysctl      -p
netstat     -plnt




directsetup () {
sudo    su
apt     -y    install    wget
wget    https://github.com/hanhongju/proxy/raw/master/trojanserver.sh    -O    setup.sh
bash    setup.sh

}




uninstall () {
sudo   su
apt    -y     remove    trojan nginx
systemctl     stop      trojan nginx
systemctl     disable   trojan nginx
netstat       -plnt

}




