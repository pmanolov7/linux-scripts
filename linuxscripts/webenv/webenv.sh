#!/bin/bash

if [ $EUID -ne 0 ]; then
 echo "Permission denied! Only root can access"
 exit 1
fi


BASE_DIR="/opt/webenv"

PUBLIC_DIR="$BASE_DIR/public/"
PRIVATE_DIR="$BASE_DIR/private/"
UPLOADS_DIR="$BASE_DIR/uploads/"

GROUP1="webteam"
GROUP2="admins"

DEV1="webdev1"
DEV2="webdev2"
ADMIN="admin1"
PASWD="changeme123"

#GROUPS

groupadd $GROUP1
groupadd $GROUP2
echo "Groups created: $GROUP1, $GROUP2"

#USERS

useradd -m -s /bin/bash $DEV1
echo "$DEV1:$PASWD" | chpasswd
useradd -m -s /bin/bash $DEV2
echo "$DEV2:$PASWD" | chpasswd
useradd -m -s /bin/bash $ADMIN
echo "$ADMIN:$PASWD" | chpasswd
echo "Users created: $DEV1, $DEV2, $ADMIN"
echo "All passwords set to $PASWD"

usermod -aG $GROUP1 $DEV1
usermod -aG $GROUP1 $DEV2
usermod -aG $GROUP1,$GROUP2 $ADMIN

echo "$DEV1 assigned to $GROUP1"
echo "$DEV2 assigned to $GROUP1"
echo "$ADMIN assigned to $GROUP1 & $GROUP2"


#DIRECTORIES

mkdir -p $PUBLIC_DIR $PRIVATE_DIR $UPLOADS_DIR

#OWNERSHIP

chown root:root $PUBLIC_DIR
chown root:$GROUP2 $PRIVATE_DIR
chown root:$GROUP1 $UPLOADS_DIR

#PERMISSIONS

chmod 2575 $PUBLIC_DIR
chmod 770 $PRIVATE_DIR
chmod 1770 $UPLOADS_DIR

echo "Directories created:"
tree -p $BASE_DIR
echo "WEB Environment ready!"
