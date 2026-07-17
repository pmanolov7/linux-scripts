#!/bin/bash

    if [[ $EUID -ne 0 ]]; then
     echo "PERMISSION DENIED - must run as root"
     exit 1
    fi

sudo userdel -r webdev1 2>/dev/null
sudo userdel -r webdev2 2>/dev/null
sudo userdel -r admin1 2>/dev/null

sudo groupdel webteam 2>/dev/null
sudo groupdel admins 2>/dev/null

sudo rm -rf /opt/webproject

echo "Teardown complete"