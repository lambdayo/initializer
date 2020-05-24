#!/bin/bash -e

# set hostname
if [ $1 ]; then hostnamectl set-hostname $1 --static; fi
# install repositories
yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum install -y https://repo.ius.io/ius-release-el7.rpm
sed -i -e 's/^metalink=/#&/g' -e 's/^#baseurl=/baseurl=/g' \
-e 's#download.fedoraproject.org/pub#mirrors.aliyun.com#g' \
/etc/yum.repos.d/epel.repo /etc/yum.repos.d/epel-testing.repo
sed -i -e 's#repo.ius.io#mirrors.aliyun.com/ius#g' \
/etc/yum.repos.d/ius-archive.repo /etc/yum.repos.d/ius.repo /etc/yum.repos.d/ius-testing.repo
yum makecache
# install rpm
yum install -y net-tools bind-utils wget nano git htop
# disable selinux
sed -i 's/^SELINUX=enforcing$/SELINUX=disabled/g' /etc/selinux/config
# unmount swap
sed -i 's/.*swap.*/#&/' /etc/fstab
# disable firewall
systemctl disable firewalld
# set timezone
timedatectl set-timezone Asia/Shanghai
# enable ntp
yum install -y ntp && systemctl enable ntpd
# set ulimit
cat <<EOF > /etc/security/limits.d/90-nproc.conf
* soft nproc 262144
* hard nproc 262144
EOF
cat <<EOF > /etc/security/limits.d/90-nofile.conf
* soft nofile 262144
* hard nofile 262144
EOF
cat <<EOF > /etc/security/limits.d/90-sigpending.conf
* soft sigpending 262144
* hard sigpending 262144
EOF
cat <<EOF > /etc/security/limits.d/90-memlock.conf
* soft memlock unlimited
* hard memlock unlimited
EOF
# set sysctl
cat <<EOF > /etc/sysctl.d/90-vm.conf
vm.max_map_count = 262144
EOF
cat <<EOF > /etc/sysctl.d/90-net.conf
net.core.somaxconn = 2048
net.ipv4.tcp_max_syn_backlog = 4096
net.ipv4.tcp_syncookies = 0
EOF
reboot
