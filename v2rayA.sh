# V2rayA客户端安装脚本 @ Debian 10 or Ubuntu 20.04
apt    update
apt    install   -y      wget
wget   https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh   -cP    /home/
wget   https://github.com/v2fly/v2ray-core/releases/download/v4.38.3/v2ray-linux-64.zip      -cP    /home/
sed    -i       ''s/read.*//g''          /home/install-release.sh
bash   /home/install-release.sh    -l    /home/v2ray-linux-64.zip
wget   https://github.com/v2rayA/v2rayA/releases/download/v1.3.3/installer_debian_amd64_v1.3.3.deb     -cP    /home/
apt    install    -y    /home/installer_debian_amd64_v1.3.3.deb
ss     -plnt
# 访问http://localhost:2017/进行客户端节点配置，socks5代理端口20170，http代理端口20171




