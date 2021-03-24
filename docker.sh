# Docker官方安装脚本安装
apt   update
apt   install   -y    curl
bash  <(curl    -sL   https://get.docker.com/)    --mirror    Aliyun
systemctl enable docker
docker run hello-world


#清空容器
systemctl restart docker
# Docker部署v2ray客户端
docker run -d -p 8000:8000 -v /home/:/home/ v2ray/official v2ray -config=/home/config.json
# Docker部署speedtest网页
docker run -d -p 80:80 ilemonrain/html5-speedtest:alpine
#容器信息
docker container ls



