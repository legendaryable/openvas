#!/bin/bash

echo "Starting setup..."
ldconfig
openvas-mkcert -q
echo "Performing NVT sync..." > /dev/null 
openvas-nvt-sync
openvassd
openvas-mkcert-client -n -i
echo "Rebuilding openvasmd db..."
openvasmd --rebuild --progress > /dev/null 
echo "Performing SCAP sync..."
openvas-scapdata-sync > /dev/null 
echo "Performing CERT sync..."
openvas-certdata-sync > /dev/null 

# ensure redis server is started
service redis-server start

echo "Creating Admin user..."
openvasmd --create-user=admin --role=Admin
echo "Setting Admin user password..."
openvasmd --user=admin --new-password=openvas
echo "Killing scanner process..."
killall openvassd
sleep 15
echo "OpenVAS 8 Setup Complete.  Waiting for Docker to finish build..."
