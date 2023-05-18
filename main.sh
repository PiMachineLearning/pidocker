#!/usr/bin/env bash

rm -f ./*.img
rm -f ./*.xz
sudo umount ./mount 
rm -rf mount
LATEST_PI_VER=$(curl 'https://downloads.raspberrypi.org/raspios_lite_armhf/images/?C=M;O=A' 2>/dev/null | grep -oP '\d\d\d\d-\d\d-\d\d' | tail -n 1) # holy hell

wget "https://downloads.raspberrypi.org/raspios_lite_armhf/images/raspios_lite_armhf-$LATEST_PI_VER/$LATEST_PI_VER-raspios-bullseye-armhf-lite.img.xz"

xz -d "$LATEST_PI_VER-raspios-bullseye-armhf-lite.img.xz"

DEVFILE=$(sudo kpartx -av "$LATEST_PI_VER-raspios-bullseye-armhf-lite.img" | grep -oP "loop\dp2")

mkdir mount

sudo mount "/dev/mapper/$DEVFILE" ./mount

sudo tar -czf - -C mount . > ./raspi.tar

docker import - pimachinelearning/raspi-os-lite:"$LATEST_PI_VER" < raspi.tar
docker import - pimachinelearning/raspi-os-lite:latest < raspi.tar

docker tag pimachinelearning/raspi-os-lite:"$LATEST_PI_VER" pimachinelearning/raspi-os-lite:"$LATEST_PI_VER"
docker tag pimachinelearning/raspi-os-lite:latest pimachinelearning/raspi-os-lite:latest

docker tag pimachinelearning/raspi-os-lite:"$LATEST_PI_VER" pimachinelearning/pidocker:"$LATEST_PI_VER"
docker tag pimachinelearning/raspi-os-lite:latest pimachinelearning/pidocker:latest

docker push pimachinelearning/raspi-os-lite:"$LATEST_PI_VER"
docker push pimachinelearning/raspi-os-lite:latest

docker push ghcr.io/pimachinelearning/pidocker:"$LATEST_PI_VER"
docker push ghcr.io/pimachinelearning/pidocker:latest

sudo umount ./mount
sudo kpartx -d "$LATEST_PI_VER-raspios-bullseye-armhf-lite.img"
rm -rf ./mount
rm "$LATEST_PI_VER"-raspios-bullseye-armhf-lite.img
