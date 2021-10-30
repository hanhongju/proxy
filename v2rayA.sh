# v2rayA客户端安装脚本 @ Debian 10 or Ubuntu 20.04
#安装v2ray-core
apt    -y    update
apt    -y    install     wget
#wget   https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh   -cP    /home/
#wget   https://github.com/v2fly/v2ray-core/releases/download/v4.38.3/v2ray-linux-64.zip      -cP    /home/
#sed    -i    ''s/read.*//g''          /home/install-release.sh
#bash   /home/install-release.sh    -l    /home/v2ray-linux-64.zip
wget    -c    https://github.com/XTLS/Xray-install/raw/main/install-release.sh
bash    install-release.sh    install
#安装v2rayA
wget   -c    https://github.com/v2rayA/v2rayA/releases/download/v1.3.3/installer_debian_amd64_v1.3.3.deb     -P    /home/
apt    -y    install     /home/installer_debian_amd64_v1.3.3.deb
#访问http://localhost:2017/进行客户端节点配置，socks5代理端口20170，http代理端口20171





