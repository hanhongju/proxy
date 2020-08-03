
#socks5代理服务器dante安装脚本@Debian 10
#安装
apt      update
apt      install    -y       dante-server net-tools
danted   -v
#编写配置文件
mv        /etc/danted.conf       /etc/danted.conf.bak
echo   '
errorlog:   /var/log/sockd.errlog
logoutput:  /var/log/socks.log
internal: eth0 port = 7000
external: eth0
clientmethod: none
socksmethod: none
user.privileged: root
user.notprivileged: nobody
client pass {
        from: 0.0.0.0/0 to: 0.0.0.0/0
        log: error connect disconnect
}
socks pass {
        from: 0.0.0.0/0 to: 0.0.0.0/0
        log: error connect disconnect
}
'      >         /etc/danted.conf
#启动服务
systemctl      restart       danted
sleep 1s
netstat  -plunt  | grep 'danted'
#回显dante监听端口


