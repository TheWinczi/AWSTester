#!/bin/bash

echo "=============================="
echo "Updating apt and installing tools"
echo "=============================="

sudo apt install -y --update

echo "=============================="
echo "Installing and configuring Nginx"
echo "=============================="

sudo apt install nginx -y
sudo touch mysite.config
sudo bash -c 'cat <<EOF > mysite.config
upstream mysite {
    server web:8000;
}

server {
    listen 80;

    location /static/ {
        root /home/ubuntu/mysite/static/;
    }

    location / {
        proxy_pass http://mysite;
    }
}
EOF'

sudo mv mysite.config /etc/nginx/sites-available/mysite
sudo rm -rf /etc/nginx/sites-enabled/default
sudo ln -s /etc/nginx/sites-available/mysite /etc/nginx/sites-enabled

echo "=============================="
echo "Restarting Nginx"
echo "=============================="

sudo systemctl start nginx
sudo systemctl enable nginx
sudo systemctl restart nginx

echo "=============================="
echo "Installation done!"
echo "=============================="