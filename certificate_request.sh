#通过cloudflare API申请证书
sudo  su
apt   -y    update
apt   -y    install    certbot python3-pip
pip         install    certbot-dns-cloudflare
echo        "dns_cloudflare_api_token = jPOSoygxMtPyzr7I47YO3WWA4WrnmFFRgc0xYZ3l"       >       /home/cloudflare_credentials.ini
certbot     certonly   --dns-cloudflare   -m   86606682@qq.com   --dns-cloudflare-credentials   /home/cloudflare_credentials.ini    -d    *.hanhongju.com    --config-dir     /home/




