#!/bin/bash

apt update
apt install docker.io -y

chmod +x /usr/bin/ctftool

cd /etc/ctf
ctftool run build
ctftool run start
