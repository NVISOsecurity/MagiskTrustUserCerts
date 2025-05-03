#!/system/bin/sh
MODDIR=${0%/*}
APEX_CERT_DIR=/apex/com.android.conscrypt/cacerts
SYS_CERT_DIR=/system/etc/security/cacerts

log() {
    echo "$(date '+%m-%d %H:%M:%S ')" "$@" >> $MODDIR/log.txt
}

inject_into_zygote(){

    log "Injecting into Zygote"

    # Collect all zygote PIDs (both 32‑ and 64‑bit)
    zygote_pids=""
    for name in zygote zygote64; do
        for p in $(pidof $name 2>/dev/null); do
            zygote_pids="$zygote_pids $p"
        done
    done

    log "Zygote PIDs: $zygote_pids"

    for zp in $zygote_pids; do
        log "zygote PID: $zp"

        log "  Injecting into $zp"
        /system/bin/nsenter --mount=/proc/$zp/ns/mnt -- /bin/mount --bind $APEX_CERT_DIR $APEX_CERT_DIR

        # Get active children
        children=$(echo "$zp" | xargs -n1 ps -o pid -P  | grep -v PID)

        # Fallback for old Android ps (columns: USER PID PPID ...):
        if [ -z "$children" ]; then
            children=$(ps \
            | awk -v PPID=$zp '$3==PPID { print $2 }')
        fi

        for pid in $children; do
            log "  Injecting into child: $pid"
            /system/bin/nsenter --mount=/proc/$pid/ns/mnt -- /bin/mount --bind $APEX_CERT_DIR $APEX_CERT_DIR

        done
    done
}

main(){
    log "MagiskTrustUserCerts - service.sh"

    # Wait for device to finish booting
    while [ "$(getprop sys.boot_completed)" != 1 ]; do
        /system/bin/sleep 1s
    done

    # In conscrypt mode, copy conscrypt certs and inject into zygote
    if [ -d "/apex/com.android.conscrypt/cacerts/" ]; then

        log "Grabbing apex certs"
        cp $APEX_CERT_DIR/* $MODDIR$SYS_CERT_DIR
        mount -t tmpfs tmpfs $SYS_CERT_DIR
        cp $MODDIR$SYS_CERT_DIR/* $SYS_CERT_DIR/

        # Fix permissions
 	    chown root:root $SYS_CERT_DIR/*
        chmod 644 $SYS_CERT_DIR/*
        chcon u:object_r:system_security_cacerts_file:s0 $SYS_CERT_DIR/*

        inject_into_zygote
    else
        # /system certs are automatically mounted by Magisk due to collection in post-fs-data
	    log "No conscrypt"
    fi

    log "Finished injecting certs"
}
main