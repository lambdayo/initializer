#!/bin/bash -e

curl -fsSL -o /etc/yum.repos.d/docker-ce.repo "https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo"
sed -i -e 's#download.docker.com#mirrors.aliyun.com/docker-ce#g' /etc/yum.repos.d/docker-ce.repo
yum install -y python-pip docker-ce
pip install docker-compose==1.23.2 -i https://pypi.doubanio.com/simple
systemctl enable docker --now
