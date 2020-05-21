#!/bin/bash

curl -fsSL -o /etc/yum.repos.d/docker-ce.repo "https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo"
yum install -y python-pip docker-ce
pip install docker-compose -i https://pypi.doubanio.com/simple
systemctl enable docker --now
