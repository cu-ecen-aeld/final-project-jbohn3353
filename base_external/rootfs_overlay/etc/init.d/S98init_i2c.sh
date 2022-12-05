#!/bin/sh
# Simple script to load i2c drivers on startup
# Usage:
#   ./S98init_i2c.sh {start|stop}

case "$1" in
    start)
        echo "load i2c drivers"
        modprobe i2c-bcm2835 || exit 1
        modprobe i2c-dev || exit 1
        ;;
    stop)
        echo "unload i2c drivers"
        rmmod i2c-dev || exit 1
        rmmod i2c-bcm2835 || exit 1

        # Remove stale nodes
        rm -f /dev/i2c-dev
        rm -f /dev/i2c-bcm2835
        ;;
    *)
        echo "Usage: $0 {start|stop}"
    exit 1
esac

exit 0