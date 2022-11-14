# AESD - Final Project Repository - Always-on IoT Workbench Remote Access Point Build System#
This repository is part of the final project submission by James Bohn for ECEN 5713: Advanced Embedded Software Design at CU Boulder.

# Repository Overview #

[Project Overview](https://github.com/cu-ecen-aeld/final-project-jbohn3353/wiki/Project-Overview)

[Project Schedule](https://github.com/cu-ecen-aeld/final-project-jbohn3353/wiki/Project-Schedule)

[Application Repo](https://github.com/cu-ecen-aeld/final-project-jbohn3353-1)

# Temporary Progress Notes #

keyname = testkey3

fwd_port = 8022

ec2 hostname = find on aws website, make static IP eventually

host:
- generate key that can be converted to DB key
- `ssh-keygen -m PEM -t rsa -b 4096 -f <key_name>`
- copy to target
- once everything else is done, ssh into target through cloud using
- `ssh -i <key_name> -p <fwd_port> root@<ec2 hostname>`

cloud:
- create ec2 instance with <key_name.pub> imported as its key pair
- allow inbound traffic on <fwd_port> from 0.0.0.0/0 using the instance's security group
- ssh into the ec2 instance using
- `ssh -i <key_name> ec2-user@<ec2 hostname>`
- set GatewayPorts to yes in /etc/ssh/sshd_config using vi
- restart ssh service with
- `sudo /etc/init.d/ssh restart`

target:
- swap console= in cmdline.txt after having flashed the sd card (so that HDMI output works)
- plug into HDMI to get the leased IP
- convert rsa ssh key to dropbear format
- `dropbearconvert openssh dropbear <key_name> <key_name>_db`
- set up port forwarding with (can add -N -o ServerAliveInterval=20 &)
- `ssh -i <key_name>_db -R <fwd_port>:127.0.0.1:22 ec2-user@<ec2 hostname>`
