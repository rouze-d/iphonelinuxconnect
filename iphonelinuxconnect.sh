#!/bin/bash
zip_dir_name=""
function install_package () {
    ./autogen.sh
    make
    make install
}
 
function unzip_name () {
    d="`mktemp -d`"
    unzip -d "$d" "$1"
    zip_dir_name="`basename "$d"/*`"
    mv "$d"/"$zip_dir_name" "$zip_dir_name"
    rmdir "$d"
}
 
function download_package_cd () {
    echo $1
    RESULT=zip$RANDOM.zip
    wget -O $RESULT "$1"
    unzip_name $RESULT
    rm $RESULT
    cd $zip_dir_name
}
#Install everything (step 1)
apt-get -y install ideviceinstaller python-imobiledevice libimobiledevice-utils python-plist usbmuxd libtool autoconf automake libxml2-dev python-dev \
    libssl-dev
download_package_cd "https://github.com/libimobiledevice/libplist/archive/master.zip"
install_package
cd ..
download_package_cd "https://github.com/libimobiledevice/libusbmuxd/archive/master.zip"
install_package
cd ..
download_package_cd "https://github.com/libimobiledevice/libimobiledevice/archive/master.zip"
install_package
cd ..
apt-get -y remove usbmuxd
apt-get -y install libimobiledevice-dev libplist-dev libusb-dev libusb-1.0.0-dev libtool-bin libtool libfuse-dev
download_package_cd "https://github.com/libimobiledevice/usbmuxd/archive/master.zip"
install_package
cd ..
download_package_cd "https://github.com/libimobiledevice/ifuse/archive/master.zip"
./autogen.sh
./configure
make
make install
cd ..
#Create a mount point (step 3)
mkdir /media/iPhone
chmod 777 /media/iPhone
# Edit the fuse configuration file (step 4)
ALLOW_COMMENT_LINE=$(grep -n "# Allow non-root users to specify the allow_other or allow_root mount options." /etc/fuse.conf | grep -Eo '^[^:]+')
sed -i "$(($ALLOW_COMMENT_LINE+1))iuser_allow_other" /etc/fuse.conf
sed -i "$(($ALLOW_COMMENT_LINE+1))iop$" /etc/fuse.conf
