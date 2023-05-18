
apt   -y    update
apt   -y    install       certbot python3-pip
pip         install       certbot-dns-cloudflare
echo        "dns_cloudflare_api_token = dxf923blezqeB2jVXP_dGGsPBuGg0nRh4FUvpMD4"     >      /home/cloudflare_credentials.ini
certbot     certonly      --dns-cloudflare        --dns-cloudflare-credentials        /home/cloudflare_credentials.ini      -d      *.hanhongju.com




