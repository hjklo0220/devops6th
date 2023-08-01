#!/bin/bash

# server ip 입력
SERVER_IP=

MANUAL="사용법: $0 [-i] [Server IP]"

# -i 인자로 server_ip가 들어오면 해당 ip 사용
# 그렇지 않으면, curl ifconfig.me 이용해서 ip자동입력


while getopts "i:" option
do
    case $option in
        s)
            SERVER_IP=$OPTARG
            ;;
        *)
            echo $MANUAL
            exit 1
            ;;
    esac
done

# 검증
if [ -z $SERVER_IP ]; then
    $SERVER_IP=$(curl ifconfig.me)
fi

# install nginx
echo "install nginx"
sudo apt install nginx

# nginx 설정 파일 생성
echo "create niginx config"
sudo sh -c "cat > /etc/nginx/sites-available/django <<EOF
server {
	listen 80;
	server_name $SERVER_IP;
	
	location / {
		proxy_pass http://127.0.0.1:8000;
		proxy_set_header Host \\\$host;
		proxy_set_header X-Real-IP \\\$remote_addr;
	}
}
EOF"

# symlink 생성
echo "create symlink"
sudo ln -s /etc/nginx/sites-available/django /etc/nginx/sites-enabled/

# restart nginx
echo "restart nginx"
sudo systemctl restart nginx

