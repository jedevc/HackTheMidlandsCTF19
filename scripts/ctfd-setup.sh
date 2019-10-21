#!/bin/bash

# ensure all sources are installed and up-to-date
apt update
apt install software-properties-common -y
add-apt-repository universe
add-apt-repository ppa:certbot/certbot
apt update

apt install nginx certbot python-certbot-nginx  -y
apt install docker.io docker-compose -y

cd /root
git clone https://github.com/CTFd/CTFd.git
cd CTFd
python -c "import os; f=open('.ctfd_secret_key', 'a+'); f.write(os.urandom(64)); f.close()"

docker-compose up -d

rm /etc/nginx/sites-enabled/default
mv /root/ctfd.nginx /etc/nginx/sites-available/ctfd
ln -s /etc/nginx/sites-available/ctfd /etc/nginx/sites-enabled/
echo "client_max_body_size 25M;" > /etc/nginx/conf.d/client-size.conf
sudo systemctl restart nginx

certbot --non-interactive --nginx --redirect --domains ctf.hackthemidlands.com --agree-tos --register-unsafely-without-email
sudo systemctl restart nginx
