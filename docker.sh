# Docker官方安装脚本安装
apt   update
apt   install   -y    curl
bash  <(curl    -sL   https://get.docker.com/)    --mirror    Aliyun
systemctl enable  docker
systemctl restart docker
docker run hello-world


#清空容器
systemctl restart docker
# Docker部署v2ray客户端
docker run -d -p 8000:8000 -v /home/:/home/ v2ray/official v2ray -config=/home/config.json
# Docker部署speedtest
docker run -d -p 80:80 ilemonrain/html5-speedtest:alpine
#容器信息
docker container ls



#添加SWAP缓存空间
if        [[   $(free  -m  |  awk   'NR==3{print $2}'   2>&1)    >   3000   ]]
then      echo   ''已经有SWAP，无需重复配置''
else      echo   ''添加SWAP空间，大小4000M''
          dd    if=/dev/zero of=/mnt/swap bs=1M count=4000
          mkswap   /mnt/swap
          swapon   /mnt/swap
          echo    '/mnt/swap swap swap defaults 0 0'      >>       /etc/fstab
fi
# Docker部署Rstudio server
docker run -d -p 8787:8787 -e DISABLE_AUTH=true rocker/rstudio









