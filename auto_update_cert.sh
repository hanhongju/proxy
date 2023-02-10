#定期更新证书
echo    '
* * * * *     date          >>          /home/crontest
0 1 * * *     apt           -y          update
0 2 * * *     apt           -y          full-upgrade
0 3 * * *     apt           -y          autoremove
0 4 * * *     mkdir         -p          /home/wordpressbackup/
0 5 * * *     mysqldump     -uroot      -pfengkuang     wordpress     >    /home/wordpress/wordpress.sql
0 6 * * *     tar           -cf         /home/wordpressbackup/wordpress$(date +\%Y\%m\%d\-\%H\%M\%S).tar        -P       /home/wordpress/
0 0 1 * *     systemctl     stop        nginx apache2
1 0 1 * *     certbot       renew
2 0 1 * *     chmod         -R   777    /etc/letsencrypt/
3 0 * * *     systemctl     restart     nginx v2ray trojan
'       |     crontab
crontab       -l
netstat       -plnt




