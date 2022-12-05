#!/bin/sh
# prints temp in F by pulling from i2c sensor and doing data manipulation and conversion
# (mostly used to demonstrate i2c functionality)
# Usage:
#   ./get_temp.sh
# Author:
#   James Bohn

set -e

sensor_addr="0x48"
sensor_reg="0"
i2c_bus="1"
temp_res=".0625"

# perform i2c read and cutoff the 0x
i2c_out=$(i2cget -y ${i2c_bus} ${sensor_addr} ${sensor_reg} w | cut -d x -f 2)

# reverse the byte order and trim the trailing 0
i2c_val_hex=$(echo -n ${i2c_out} | tail -c 2)$(echo -n ${i2c_out} | head -c 1)

# convert lowercase hex digits to upper so bc behaves
i2c_val_hex=$(echo ${i2c_val_hex} | tr '[:lower:]' '[:upper:]')

# convert from hex to dec
i2c_val_dec=$(echo "ibase=16; $i2c_val_hex" | bc)

# perform 2's complement adjustment if necessary
if [ ${i2c_val_dec} -ge 2048 ]; then
    i2c_val_dec=$((${i2c_val_dec}-4096))
fi

# do the temperature calculation and conversion in one step
expr ${i2c_val_dec}*${temp_res}*1.8+32 | bc
