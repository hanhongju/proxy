# Shadowsocks 服务器安装脚本 @ Debian 10 or Ubuntu 18.04
apt      update
apt      install     -y    shadowsocks-libev
#创建shadowsocks-server配置文件
echo '
{"server":["[::0]", "0.0.0.0"]
,"server_port": 10086
,"password":"fengkuang"
,"timeout":60
,"mode":"tcp_and_udp"
,"method":"aes-256-gcm"
}
'     >           /etc/shadowsocks-libev/config.json
#重启服务
systemctl   enable      shadowsocks-libev
systemctl   restart     shadowsocks-libev
sleep       1s
ss         -plnt
#回显ss-server监听端口



# Shadowsocks 客户端使用脚本
apt      update
apt      install     -y    shadowsocks-libev
#写入服务器信息
echo   '
{"server": "one.thenote.site"
,"server_port": 10086
,"local_address": "0.0.0.0"
,"local_port": 9000
,"password": "fengkuang"
,"timeout": 60
,"mode": "tcp_and_udp"
,"method": "aes-256-gcm"
}
'         >        /etc/shadowsocks-libev/root.json
#启动服务
systemctl   enable      shadowsocks-libev-local@root
systemctl   restart     shadowsocks-libev-local@root
sleep       1s
ss         -plnt
#回显ss-local监听端口



#设置tsocks透明代理
apt      install     -y    tsocks
echo '
server       =  127.0.0.1
server_type  =  5
server_port  =  9000
default_user =  none
default_pass =  none
'          >              /etc/tsocks.conf
#测试代理可用性
tsocks    wget    https://cn.wordpress.org/latest-zh_CN.tar.gz   -cP   /home/wordpress/





