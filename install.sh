#!/bin/sh
echo '正在安装依赖'
if cat /etc/os-release | grep "centos" > /dev/null
    then
    yum update
    yum install unzip wget curl -y > /dev/null
else
    apt-get update
    apt-get install unzip wget curl -y > /dev/null
fi

api=$1
key=$2
nodeId=$3
localPort=$4
license=$5

systemctl stop firewalld
systemctl disable firewalld
systemctl stop v2ray.service
echo '结束进程'
sleep 3
rm -f /etc/systemd/system/v2ray.service
rm -rf $key
mkdir $key
cd $key
wget https://github.com/tokumeikoi/aurora/releases/latest/download/aurora
wget https://github.com/v2ray/v2ray-core/releases/latest/download/v2ray-linux-64.zip
wget https://dpsky.cn/vvlink-a07wm6/v2ray.key
wget https://dpsky.cn/vvlink-a07wm6/v2ray.pem
cp v2ray.pem v2ray.key /home

unzip v2ray-linux-64.zip
chmod 755 *
cat << EOF >> /etc/systemd/system/vvlink.service
[Unit]
Description=vvLink Service
After=network.target
Wants=network.target

[Service]
Type=simple
PIDFile=/run/vvlink.pid
ExecStart=/root/$key/aurora -api=$api -token=$key -node=$nodeId -localport=$localPort -license=$license
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl enable vvlink
systemctl start vvlink
echo '部署完成'
sleep 3
systemctl status vvlink
