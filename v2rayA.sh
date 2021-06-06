

apt    update
apt    install   -y       curl nginx certbot wget unzip
wget   https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh   -cP    /home/
wget   https://github.com/v2fly/v2ray-core/releases/download/v4.38.3/v2ray-linux-64.zip      -cP    /home/
sed    -i       ''s/read.*//g''          /home/install-release.sh
bash   /home/install-release.sh    -l    /home/v2ray-linux-64.zip
systemctl   disable   v2ray   --now

#\cp    /home/config.json    /usr/local/etc/v2ray/config.json


wget   https://github.com/v2rayA/v2rayA/releases/download/v1.3.3/installer_debian_amd64_v1.3.3.deb     -cP    /home/
apt    install    -y    /home/installer_debian_amd64_v1.3.3.deb


