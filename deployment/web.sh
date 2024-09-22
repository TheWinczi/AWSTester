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
cd $ROOT_DIR

echo "=============================="
echo "Downloadnig repository content"
echo "=============================="

sudo git clone $REPOSITORY .

echo "=============================="
echo "Installing packages"
echo "=============================="

cd mysite
sudo python3 -m venv venv
source venv/bin/activate
sudo venv/bin/pip install -r requirements.txt

echo "=============================="
echo "Making gunicorn service"
echo "=============================="

sudo touch gunicorn.service
sudo bash -c 'cat <<EOF > gunicorn.service
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
EOF'

sudo mv gunicorn.service /etc/systemd/system/gunicorn.service
sudo systemctl daemon-reload
sudo systemctl enable gunicorn
sudo systemctl start gunicorn

echo "=============================="
echo "Installation done!"
echo "=============================="
