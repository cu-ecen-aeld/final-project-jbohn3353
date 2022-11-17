#!/bin/sh
# start persistent ssh connection to forward remote port on boot, kill on shutdown
# Usage:
#   ./S99schedulesshfwd.sh {start|stop}
# Author:
#   James Bohn

case "$1" in
    start)
        echo "start persistent ssh fwd"
        /root/retry_fwd.sh &
        ;;
    stop)
        echo "kill persistent ssh fwd"
        killall retry_fwd.sh
        ;;
    *)
        echo "Usage: $0 {start|stop}"
    exit 1
esac

exit 0
