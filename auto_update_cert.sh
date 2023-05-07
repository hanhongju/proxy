#定期更新证书
sudo    su
echo    '
* * * * *     date          >>          /home/crontest
0 1 * * *     apt           -y          update
0 2 * * *     apt           -y          full-upgrade
0 3 * * *     apt           -y          autoremove
0 0 1 * *     systemctl     stop        nginx
1 0 1 * *     certbot       renew
2 0 1 * *     chmod         -R   777    /etc/letsencrypt/
3 0 * * *     systemctl     restart     nginx trojan
'       |     crontab
crontab       -l
netstat       -plnt




