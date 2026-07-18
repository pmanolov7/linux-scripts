#!/bin/bash

if [ $EUID -ne 0 ]; then
 echo "Permission denied! Only root can access this!"
 exit 1
fi

BASE_DIR="/opt/webenv"

GROUP1="webteam"
GROUP2="admins"

DEV1="webdev1"
DEV2="webdev2"
ADMIN="admin1"

#USERS

pkill -u $DEV1 2>/dev/null
userdel -r $DEV1 && echo "$DEV1 successfully deleted!" || echo "Couldn't delete $DEV1!"

pkill -u $DEV2 2>/dev/null
userdel -r $DEV2 && echo "$DEV2 successfully deleted!" || echo "Couldn't delete $DEV2!"

pkill -u $ADMIN 2>/dev/null
userdel -r $ADMIN && echo "$ADMIN successfully deleted!" || echo "Couldn't delete $ADMIN!"

#GROUPS
groupdel $GROUP1 && echo "$GROUP1 successfully deleted!" || echo "Couldn't delete $GROUP1!"
groupdel $GROUP2 && echo "$GROUP2 successfully deleted!" || echo "Couldn't delete $GROUP2!"

rm -rf $BASE_DIR && echo "Directories removed!" || echo "Couldn't remove directories!"