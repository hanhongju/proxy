#trojan客户端使用脚本@Debian 10
#安装trojan
apt  update
apt  install  -y   trojan net-tools
systemctl  enable  trojan 
#写入配置文件
echo   '
{
    "run_type": "client",
    "local_addr": "::",
    "local_port": 5000  ,
    "remote_addr": "<domain>",
    "remote_port": 443,
    "password": ["fengkuang"],
    "log_level": 1,
    "ssl": {
        "verify": true,
        "verify_hostname": true,
        "alpn": ["http/1.1"]
    }
}
'     >     /etc/trojan/config.json
#启动客户端
service   trojan  restart
trojan   -t
netstat  -plnt
#回显trojan监听地址





#设置tsocks透明代理
apt  install    -y   tsocks
echo '
server       =  127.0.0.1
server_type  =  5
server_port  =  5000
default_user =  none
default_pass =  none
'          >              /etc/tsocks.conf
#测试代理可用性
tsocks      wget     https://cn.wordpress.org/latest-zh_CN.tar.gz      -O     /home/latest-zh_CN.tar.gz



