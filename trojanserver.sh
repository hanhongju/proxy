# Trojan安装脚本 @ Debian 10 or Ubuntu 20.04
echo    "
本脚本可以自动安装trojan，自动申请并使用tls证书加密保护trojan的流量，反代朝鲜劳动新闻网进行网站伪装。需要您事先将此VPS的IP地址解析到一个有效域名上。
如果此VPS使用KVM虚拟技术，此脚本自动开启BBR加速。
理解这些信息后请按回车键继续，并在下一栏输入您解析的有效域名。如果域名输入有误请按Ctrl+C终止脚本运行，然后重新运行脚本。
"
read    nothing
echo    "请输入此VPS的IP对应的域名地址："
read    site
echo    "好的，现在要开始安装了。"
sleep   5s
#计时
begin=$(date +%s)
#安装软件：
apt    update
apt    install   -y     python3-pip trojan
pip3   install  --upgrade   cryptography certbot
#申请SSL证书
systemctl     stop     nginx apache2
certbot       certonly    --standalone    --agree-tos     -n     -d      $site     -m    86606682@qq.com 
cp           /etc/letsencrypt/live/$site/*      /home/
chmod        -Rf    777    /home/
#配置证书每月1日自动更新
echo       "
0 0 1 * *     systemctl     stop        nginx apache2
1 0 1 * *     certbot       renew
2 0 1 * *     cp           /etc/letsencrypt/live/$site/*          /home/
3 0 1 * *     chmod        -Rf          777       /home/
4 0 1 * *     systemctl     restart     trojan cron
"      |      crontab
#修改系统控制文件启用BBR
echo     '
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
'         >       /etc/sysctl.conf
#修改trojan配置文件
echo '
{"run_type": "server"
,"local_addr": "::"
,"local_port": 443
,"remote_addr": "www.rodong.rep.kp"
,"remote_port": 80
,"password": ["fengkuang"]
,"ssl": {"cert": "/home/fullchain.pem"
        ,"key" : "/home/privkey.pem"
        ,"alpn": ["http/1.1"]
        }
}
'           >          /etc/trojan/config.json
#启动trojan
systemctl     enable      trojan cron
systemctl     restart     trojan cron
#显示监听端口
sleep       1s
trojan     -t
sysctl     -p
crontab    -l
ss         -plnt
if          [[  $(ss   -plnt     2>&1 )   =~   trojan   ]]
then        echo   "至此，trojan可正常工作。服务器密码为fengkuang。"
else        echo   "您输入的域名地址可能没有正确解析或者短时间申请了太多的证书，不能正常申请证书，所以trojan不能正常工作。在您确认了域名解析没有问题后再请重新运行本脚本。"
fi
finish=$(date +%s)
timeconsume=$(( finish - begin ))
echo   "脚本运行时间$timeconsume秒。"
#至此trojan可正常工作







