# AESD - Final Project Repository - Always-on IoT Workbench Remote Access Point Build System 
This repository is part of the final project submission by James Bohn for ECEN 5713: Advanced Embedded Software Design at CU Boulder.

# Repository Overview #

[Project Overview](https://github.com/cu-ecen-aeld/final-project-jbohn3353/wiki/Project-Overview)

[Project Schedule](https://github.com/cu-ecen-aeld/final-project-jbohn3353/wiki/Project-Schedule)

[Application (Host) Repo](https://github.com/cu-ecen-aeld/final-project-jbohn3353-1)

# Setup and Usage #

Through these instructions there will be terms in triangle brackets used to represent substitions, these can be chosen by the user as long as they are consistent across uses except for the instance IP which will be provided by AWS.

## EC2 Instance ##
1. generate a keypair using `ssh-keygen -m PEM -t rsa -b 4096 -f <key_name>`. The public key will be `~/.ssh/<key_name>.pub` and the private key will be `~/.ssh/<key_name>`
2. Follow EC2 setup instructions [here](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EC2_GetStarted.html). When asked for a key pair, choose to upload the public key you just created in the step above
3. In the AWS GUI for EC2, change the instance's security group to allow inbound traffic on <fwd_port> from 0.0.0.0/0 using info from [here](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/authorizing-access-to-an-instance.html)
4. Additionally, acquire an associate a static ip with your instance using info from [here](https://aws.amazon.com/premiumsupport/knowledge-center/ec2-associate-static-public-ip/) (specifically under the Resolution section). This is <ec2_ip>
5. After turning the instance on, ensure you can connect to it using `ssh -i ~/.ssh/<key_name> ec2_user@<ec2_ip>`
6. While connected to the instance, set GatewayPorts to yes in `/etc/ssh/sshd_config` using vi and restart the ssh service with `sudo /etc/init.d/ssh restart`

## Building for Target ##
1. Clone this repo onto any host suited for building the target
2. Run a quick `git submodule update --init --recursive` to make sure buildroot is up to date
3. In order for our target to use ssh correctly, we must convert our ssh key to a format it understands. This is done with `dropbearconvert openssh dropbear ~/.ssh/<key_name> ~/.ssh/<key_name>_db`
4. After the converstion, place the dropbear key somewhere in `base_external/rootfs_overlay` ideally `base_external/rootfs_overlay/root/.ssh`
5. IMPORTANT: In `base_external/rootfs_overlay/root/fwd_ssh.sh` fill in the default values for <fwd_port>, <ec2_ip>, as well as the path to wherever you put <key_name>_db above. This is necessary for the automation on the target to work and know where the ec2 instance is and how it can connect to it.
6. Simply run `./build.sh` twice in order to kick off the buildroot build. If building for the first time or doing a clean build, this may take between 30 minutes and 2 hours depending on the build HW
7. After the build is complete, use [rufus](https://rufus.ie/en/) or another utility to flash the sdcard image from buildroot/images/sdcard.img onto an actual sd card before taking it back to the target to boot up

## Common Usage ##
1. Clone the [Host Repo](https://github.com/cu-ecen-aeld/final-project-jbohn3353-1) onto the host intended to be used for remote access. This system either needs to be a linux system or have something like cygwin or WSL installed in order to support bash and ssh easily.
2. Once installed, make sure you get the ec2 private key to this machine somehow as well.
3. IMPORTANT: Just as with the target, go into the `connect_to_target.sh` script and update the default values based on where you put the private key, <fwd_port>, and <ec2_ip>. You can also add the instance ID for auto starting the instance with the script, but more on that later.
4. So long as the target is on and the EC2 instance is running, running the `connect_to_target.sh` script should open up an ssh connection with the target. If there are any hiccups with this, try restarting both the target and the ec2 instance while you can
5. Once SSH'd into the target, there are three main functionalities available. Power control using Wake on Lan, I2C control using linux I2C utilities, and GPIO control using linux GPIO utilities.
6. For WoL, use `ether-wake -b <MAC address>` to generate a WoL packet for a specific MAC address
7. For I2C, use utilites like `i2cdetect`, `i2cget`, and `i2cset` to interact with devices connected to the bus. More on that [here](https://linuxhint.com/i2c-linux-utilities/)
8. For GPIO, interact with indvidual pins using sysfs like discussed [here](https://www.kernel.org/doc/Documentation/gpio/sysfs.txt)

## Auto Instance Start from Host Script ##
This is a little more involved and definitely not necessary but is a nice quality of life improvement. As mentioned above, it is possible to have the host script also turn on the EC2 instance if it's not already running. 
1. Install aws CLI following [these](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) docs
2. Create priviledged user following [these](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users_create.html#id_users_create_console) steps. Make sure to give the user EC2FullAccess furing the permissions step.
3. Run `aws configure` on the host and input the info from user creation to validate your host.
4. Finally, udpate the default instance ID in `connect_to_target.sh` or set it manually when called using the -ss flag
