#!/bin/sh
# Simple script to demonstrate GPIO functionality during start up
# Usage:
#   ./S99init_gpio.sh {start|stop}

gpio_pin="12"

case "$1" in
    start)
        echo "turn on GPIO"
        echo ${gpio_pin} > /sys/class/gpio/export
        echo out > /sys/class/gpio/gpio${gpio_pin}/direction
        echo 1 > /sys/class/gpio/gpio${gpio_pin}/value
        ;;
    stop)
        echo "turn off GPIO"
        echo 0 > /sys/class/gpio/gpio${gpio_pin}/value
        echo ${gpio_pin} > /sys/class/gpio/unexport
        ;;
    *)
        echo "Usage: $0 {start|stop}"
    exit 1
esac

exit 0