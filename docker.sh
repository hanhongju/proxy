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
# Docker部署Rstudio server
docker run -d -p 8787:8787 -e DISABLE_AUTH=true rocker/rstudio
#容器信息
docker container ls







