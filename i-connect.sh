#!/bin/bash

if [[ $EUID -ne 0 ]]; then
    echo -e "run script with ROOT (sudo)"
    exit 1
fi

sudo LD_LIBRARY_PATH=/usr/local/lib usbmuxd
sleep 1
export LD_LIBRARY_PATH=/usr/local/lib
sleep 1
idevicepair pair
echo "check your iphone and press 'trust'"
sleep 1
ifuse /media/iPhone/
sleep 1
echo "Done"
