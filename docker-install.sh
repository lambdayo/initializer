#!/bin/bash -e

curl -fsSL -o /etc/yum.repos.d/docker-ce.repo "https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo"
yum install -y python-pip docker-ce
pip install docker-compose==1.24.1 -i https://pypi.doubanio.com/simple
systemctl enable docker --now
