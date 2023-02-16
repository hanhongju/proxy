#定期更新证书
echo    '
* * * * *     date          >>          /home/crontest
0 1 * * *     apt           -y          update
0 2 * * *     apt           -y          full-upgrade
0 3 * * *     apt           -y          autoremove
0 0 1 * *     systemctl     stop        nginx apache2
1 0 1 * *     certbot       renew
2 0 1 * *     chmod         -R   777    /etc/letsencrypt/
3 0 * * *     systemctl     restart     nginx v2ray trojan
'       |     crontab
crontab       -l
netstat       -plnt




autoupdatecert () {
sudo    su
apt     -y    install    wget
wget    https://github.com/hanhongju/proxy/raw/master/auto_update_cert.sh    -O    setup.sh
bash    setup.sh

}




