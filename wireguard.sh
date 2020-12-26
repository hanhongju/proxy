#  Wireguard安装脚本 @ Ubuntu 20.04
apt   update
apt   install   -y   wireguard net-tools

#开启流量转发
echo "
net.ipv4.ip_forward = 1
net.ipv6.conf.all.forwarding = 1
" >> /etc/sysctl.conf
sysctl   -p
systemctl enable wg-quick@wg0

#创建两对公私钥，分别给服务器和客户端
wg  genkey  | tee  pri1  |   wg  pubkey   >pub1
wg  genkey  | tee  pri2  |   wg  pubkey   >pub2

#读取网卡名称和IP地址
interface=$(ip -o  -4  route show to default | awk  '{print $5}')
ipv4=$(ip addr show dev "$interface" | grep -oP  '(?<=inet\s)\d+(\.\d+){3}'   )
ipv6=$(ip addr show dev "$interface" | sed  -e   's/^.*inet6 \([^ ]*\)\/.*$/\1/;t;d'   | head -1   )

#生成服务器配置文件
echo  "
[Interface]
PrivateKey = $(cat pri1)
Address = 192.168.0.1/24, 2001:20:2333::1/28
ListenPort = 500
SaveConfig = true
DNS = 8.8.8.8, 2001:4860:4860::8888
PostUp   = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o $interface -j MASQUERADE; ip6tables -A FORWARD -i wg0 -j ACCEPT; ip6tables -t nat -A POSTROUTING -o $interface -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o $interface -j MASQUERADE; ip6tables -D FORWARD -i wg0 -j ACCEPT; ip6tables -t nat -D POSTROUTING -o $interface -j MASQUERADE

[Peer]
PublicKey  =  $(cat pub2)
AllowedIPs = 192.168.0.0/24, 2001:20:2333::1/28
"    >     /etc/wireguard/wg0.conf

#生成客户端配置文件
echo  "
[Interface]
PrivateKey = $(cat pri2)
Address = 192.168.0.2/24, 2001:20:2333::666/28
DNS = 8.8.8.8, 2001:4860:4860::8888

[Peer]
PublicKey  =  $(cat pub1)
Endpoint   =  [$ipv6]:500
AllowedIPs = 0.0.0.0/0, ::0/0
PersistentKeepalive = 25
"    >     client.conf



#启动服务
wg-quick  down wg0
wg-quick  up   wg0  ||  {
     echo   启动wireguard失败，请检查/etc/wireguard/wg0.conf是否存在错误
}
wg
echo    "--------以下是客户端配置文件，请保存并在客户端中使用---------"
cat      client.conf









