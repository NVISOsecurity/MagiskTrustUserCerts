mkdir -p $MODPATH/system/etc/security/cacerts
rm -f $MODPATH/system/etc/security/cacerts/*
cp -f /data/misc/user/0/cacerts-added/* $MODPATH/system/etc/security/cacerts/

