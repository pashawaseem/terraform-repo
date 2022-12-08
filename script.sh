#!/bin/bash
sudo apt update
sudo apt install nginx -y
echo "This is the sample page.." >/var/www/html/index.nginx-debian.html