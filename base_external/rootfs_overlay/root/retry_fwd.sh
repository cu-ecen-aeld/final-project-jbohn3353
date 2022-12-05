#!/bin/sh
# called during start in the background to continuosly attempt to forward the ssh
# port from the remote instance, retrying on closure after a delay
# Usage:
#   ./retry_fwd.sh
# Author:
#   James Bohn

set -e

retry_delay=5

while : ; do
    echo $(/root/fwd_ssh.sh) # this echo wrapper appears to prevent the scipt
                             # from crashing. More testing/research/questions
                             # needed to figure out why
    sleep ${retry_delay}
done