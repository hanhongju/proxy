#定期更新证书
sudo    su
echo    '
* * * * *     date   >>    /home/crontest
0 1 * * *     apt    -y    update
0 2 * * *     apt    -y    full-upgrade
0 3 * * *     apt    -y    autoremove
1 0 1 * *     certbot      renew
'       |     crontab
crontab       -l
netstat       -plnt




