#Docker官方安装脚本安装
apt   update
apt   install   -y    curl
curl       -fsSL      https://get.docker.com    |    bash    -s    docker    --mirror    Aliyun
docker      run       hello-world



#Docker部署v2ray客户端
#读取节点信息，启动容器
docker    rm         -f          v2ray
docker    run        -d        --name      v2ray      -p       8000:8000     -v       /home/:/home/       v2ray/official     v2ray     -config=/home/config.json
docker    logs        v2ray
docker    container   ls
#回显容器信息

