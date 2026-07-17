#!/bin/bash

sudo userdel -r webdev1 2>/dev/null
sudo userdel -r webdev2 2>/dev/null
sudo userdel -r admin1 2>/dev/null

sudo groupdel webteam 2>/dev/null
sudo groupdel admins 2>/dev/null

sudo rm -rf /opt/webproject

echo "Teardown complete"