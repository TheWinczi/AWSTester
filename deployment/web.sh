#!/bin/bash

REPOSITORY="https://github.com/TheWinczi/AWSTester.git"
ROOT_DIR="/var/www/html/"


echo "=============================="
echo "Updating apt and installing tools"
echo "=============================="

sudo apt install -y --update
sudo apt install -y git
sudo apt install -y python3 python3-venv

echo "=============================="
echo "Making directory"
echo "=============================="

sudo mkdir -p $ROOT_DIR
sudo -s cd $ROOT_DIR

echo "=============================="
echo "Downloadnig repository content"
echo "=============================="

sudo git clone $REPOSITORY .

echo "=============================="
echo "Installing packages"
echo "=============================="

sudo -s cd mysite
sudo python3 -m venv venv
sudo source venv/bin/activate
sudo venv/bin/pip install -r requirements.txt

echo "=============================="
echo "Making gunicorn service"
echo "=============================="

cat <<EOT > gunicorn.service
[Unit]
Description=Gunicorn instance to serve application
After=network.target

[Service]
User=ubuntu
Group=ubuntu
WorkingDirectory=/var/www/html/mysite
ExecStart=/var/www/html/mysite/venv/bin/gunicorn -c gunicorn.py mysite.wsgi
ExecReload=/bin/kill -s HUP $MAINPID
KillMode=mixed
TimeoutStopSec=5
PrivateTmp=true

[Install]
WantedBy=multi-user.target
EOT

sudo mv gunicorn.service /etc/systemd/system/gunicorn.service
sudo systemctl daemon-restart
sudo systemctl enable gunicorn
sudo systemctl start gunicorn


echo "=============================="
echo "Installing and configuring Nginx"
echo "=============================="

sudo apt install nginx -y
cat <<EOT > mysite.nginx
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
EOT

sudo mv mysite.nginx /etc/nginx/sites-available/mysite
sudo rm -rf /etc/nginx/sites-enabled/default
sudo ln -s /etc/nginx/sites-available/mysite /etc/nginx/site-enabled

echo "=============================="
echo "Restarting Nginx"
echo "=============================="

sudo systemctl start nginx
sudo systemctl enable nginx
sudo systemctl restart nginx

echo "=============================="
echo "Installation done!"
echo "=============================="
