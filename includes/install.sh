#!/bin/bash
echo
echo "installing Hostapd/Karma Dependencies..."
echo 

apt-get -y install gcc-4.7
apt-get -y install g++-4.7
update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.7 40 --slave /usr/bin/g++ g++ /usr/bin/g++-4.7
apt-get -y install hostapd
apt-get -y install libnl1 libnl-dev libssl-dev

echo
echo "Getting Hostapd/Karma..."
echo

git clone https://github.com/xtr4nge/hostapd-karma

    echo "--------------------------------"
    echo "ADDING: CONFIG_LIBNL32=y / SLL TLS patch)"
    echo "--------------------------------"
    
    apt-get -y install libnl-3-dev libnl-genl-3-dev
    
    EXEC="s,^#CFLAGS += -I/usr/include/libnl3,CFLAGS += -I/usr/include/libnl3,g"
    sed -i "$EXEC" hostapd-karma/hostapd/.config
    
    EXEC="s,^#CONFIG_LIBNL32=y,CONFIG_LIBNL32=y,g"
    sed -i "$EXEC" hostapd-karma/hostapd/.config

    EXEC="s,^#CONFIG_TLS=openssl,CONFIG_TLS=none,g"
    sed -i "$EXEC" hostapd-karma/hostapd/.config

    
    echo "[Patching completed]"
    echo

echo
echo "Building Hostapd/Karma..."
echo

cd hostapd-karma/hostapd
make

echo 
echo "Copying Hostapd/Karma..."
echo 
cp hostapd ../../
cp hostapd_cli ../../

echo 
echo "Cleaning Up..."
echo

cd..
cd..
rm -r hostapd-karma

echo "..DONE.."
exit
