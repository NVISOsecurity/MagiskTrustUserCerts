#!/system/bin/sh
MODDIR=${0%/*}
APEX_CERT_DIR=/apex/com.android.conscrypt/cacerts
SYS_CERT_DIR=/system/etc/security/cacerts

log() {
    echo "$(date '+%m-%d %H:%M:%S ')" "$@" >> $MODDIR/log.txt
}

has_mount() {
  local pid="$1"
  grep -q " $APEX_CERT_DIR " "/proc/$pid/mountinfo"
}

monitor_zygote(){

    (
    while true; do

        # Collect all zygote PIDs (both 32‑ and 64‑bit)
        zygote_pids=""
        for name in zygote zygote64; do
            for p in $(pidof $name 2>/dev/null); do
                zygote_pids="$zygote_pids $p"
            done
        done

        for zp in $zygote_pids; do

            # if our bind isn’t present, re-apply it
            if ! has_mount "$pid"; then

                # Get active children
                children=$(echo "$zp" | xargs -n1 ps -o pid -P  | grep -v PID)

                # Fallback for old Android ps (columns: USER PID PPID ...):
                if [ -z "$children" ]; then
                    children=$(ps \
                    | awk -v PPID=$zp '$3==PPID { print $2 }')
                fi

                # After a crash, zygote is a bit unstable, so waiting to settle.
                if [ "$(echo "$children" | wc -l)" -lt 5 ]; then
                    /system/bin/sleep 1s
                    continue
                fi

                log "Injecting into zygote ($zp)"
                /system/bin/nsenter --mount=/proc/$zp/ns/mnt -- /bin/mount --rbind $SYS_CERT_DIR $APEX_CERT_DIR


                for pid in $children; do
                    if ! has_mount "$pid"; then
                        log "  Injecting into child $pid"
                        /system/bin/nsenter --mount=/proc/$pid/ns/mnt -- /bin/mount --rbind $SYS_CERT_DIR $APEX_CERT_DIR
                    fi
                done
            fi
        done
        sleep 5
    done
    )&
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

        monitor_zygote
    else
        # /system certs are automatically mounted by Magisk due to collection in post-fs-data
	    log "No conscrypt"
    fi

    log "Finished injecting certs"
}
main