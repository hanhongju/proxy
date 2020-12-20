#  Wireguard安装脚本

apt   update
apt   install   -y   wireguard

config_dir= "$HOME/.wireguard/"

mkdir  -p  "$config_dir"
cd  "$config_dir"  ||  {
    echo   切换目录失败，程序退出
    exit
}

#创建两对公私钥，分别给服务器和客户端
wg  genkey  | tee  pri1  |   wg  pubkey   >pub1
wg  genkey  | tee  pri2  |   wg  pubkey   >pub2
chmod  600  pri1
chmod  600  pri2

#读取网卡名称和IP地址
interface=$(ip -o  -4  route show to default | awk  '{print $5}')
ip=$(ip -4 addr show  "$interface" | grep -oP '(?<=inet\s)\d+(\.\d+){3}')

#生成服务器配置文件
cat  >wg0.confi <<EOL
[Interface]
PrivateKey = $(cat pri1)
Address = 10.10.10.1
ListenPort = 54321
PostUp   = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -A FORWARD -o wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o $interface -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -D FORWARD -o wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o $interface -j MASQUERADE
[Peer]
PublicKey  =  $(cat pub2)
AllowedIPs =  10.10.10.2/32
EOL

#生成客户端配置文件
cat  >client.confi <<EOL
[Interface]
PrivateKey = $(cat pri2)
Address = 10.10.10.2
DNS = 8.8.8.8
[Peer]
PublicKey  =  $(cat pub1)
Endpoint   =  $ip:54321
AllowedIPs =  0.0.0.0/0
EOL

cp  wg0.conf    /etc/wireguard/  || {
    echo 复制失败
    exit
}


wg-quick up wg0  ||  {
     echo   启动wireguard失败，请检查/etc/wireguard/wg0.conf是否存在错误
     exit
}


echo    "--------以下是客户端配置文件，请保持并在客户端中使用---------"
cat   client.conf





