#通过cloudflare API申请证书
sudo  su
site=hanhongju.com
apt   -y    update
apt   -y    install    certbot python3-pip
pip         install    certbot-dns-cloudflare
echo        "dns_cloudflare_api_token = jPOSoygxMtPyzr7I47YO3WWA4WrnmFFRgc0xYZ3l"       >       /home/cloudflare_credentials.ini
certbot     certonly  --agree-tos  --eff-email    -m   86606682@qq.com  --dns-cloudflare     --dns-cloudflare-credentials   /home/cloudflare_credentials.ini    -d    *.$site
chmod   -R  777  /etc/letsencrypt/
cp      /etc/letsencrypt/live/$site/fullchain.pem     /home/fullchain.pem
cp      /etc/letsencrypt/live/$site/privkey.pem       /home/privkey.pem



