#!/bin/sh
# start remote ssh port forwarding with default parameters
# Usage:
#   ./fwd_ssh.sh [keypath] [port] [instance_ip]
# Author:
#   James Bohn

set -e

default_keypath="/root/.ssh/ec2_key_db.priv"
default_port="8022"
default_instance_ip="34.224.219.227"

keypath=${1:-${default_keypath}}
port=${2:-${default_port}} 
instace_ip=${3:-${default_instance_ip}  }

ssh -y -N -i ${keypath} -R ${port}:127.0.0.1:22 ec2-user@${instace_ip}

exit $?
