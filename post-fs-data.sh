# Certificates are collected during post-fs-data so that they are auto-mounted on top of /system for non-conscrypt devices
MODDIR=${0%/*}
SYS_CERT_DIR=/system/etc/security/cacerts

log() {
    echo "$(date '+%m-%d %H:%M:%S ')" "$@" >> $MODDIR/log.txt
}

collect_user_certs(){

    mkdir -p -m 700 $MODDIR$SYS_CERT_DIR

    log "Grabbing user certs"
    # Add the user-defined certs, looping over all available users
    for dir in /data/misc/user/*; do
        if [ -d "$dir/cacerts-added" ]; then
            for cert in "$dir/cacerts-added"/*; do
                cp "$cert" $MODDIR$SYS_CERT_DIR/
                log "Grabbing user cert: $(basename "$cert")"
            done
        fi
    done
}

main(){
    echo "" > $MODDIR/log.txt
    log "MagiskTrustUserCerts - post-fs-data.sh"

    collect_user_certs

    log "Grabbing /system certs"
    cp $SYS_CERT_DIR/* $MODDIR$SYS_CERT_DIR
}
main