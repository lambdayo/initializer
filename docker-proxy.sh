#!/bin/bash -e

DIR=/etc/systemd/system/docker.service.d
SERVER_ADDRESS=SERVER_ADDRESS
ACTION=ACTION

options=':ius:'
while getopts $options option
do
  case $option in
    i ) ACTION=install ;;
    u ) ACTION=uninstall ;;
    s ) SERVER_ADDRESS=$OPTARG ;;
    * ) echo "Unimplemented option" >&2; exit 1 ;;
  esac
done
shift $((OPTIND-1))

install(){
  [ -d $DIR ] || mkdir -p $DIR
  cat <<EOF > $DIR/http-proxy.conf
[Service]
Environment="HTTPS_PROXY=socks5://$SERVER_ADDRESS/"
Environment="NO_PROXY=hub-mirror.c.163.com,quay.mirrors.ustc.edu.cn,registry.cn-hangzhou.aliyuncs.com"
EOF
  systemctl daemon-reload
  systemctl restart docker
}

uninstall(){
  rm -rf $DIR
  systemctl daemon-reload
  systemctl restart docker
}

if [ $ACTION == install ]
then
  install
elif [ $ACTION == uninstall ]
then
  uninstall
else
  echo "Unimplemented option" >&2; exit 1
fi
