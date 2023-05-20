#定期更新证书
sudo    su
echo    '
* * * * *     date          >>          /home/crontest
0 1 * * *     apt           -y          update
0 2 * * *     apt           -y          full-upgrade
0 3 * * *     apt           -y          autoremove
1 0 1 * *     certbot       renew       --pre-hook "systemctl stop nginx"      --post-hook "systemctl restart nginx"       --deploy-hook "chmod -R 777 /etc/letsencrypt/" 
'       |     crontab
crontab       -l
netstat       -plnt




