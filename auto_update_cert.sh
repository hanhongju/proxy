#定期更新证书
sudo    su
echo    '
* * * * *     date          >>          /home/crontest
0 1 * * *     apt           -y          update
0 2 * * *     apt           -y          full-upgrade
0 3 * * *     apt           -y          autoremove
1 0 1 * *     certbot       renew       --pre-hook "service nginx stop"     --post-hook "service nginx trojan start"       --deploy-hook "chmod -R 777 /etc/letsencrypt/" 
'       |     crontab
crontab       -l
netstat       -plnt




