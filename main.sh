#!/usr/bin/env bash

rm -f ./*.img
rm -f ./*.xz
sudo umount ./mount 
rm -rf mount

wget "https://downloads.raspberrypi.org/raspios_lite_armhf/root.tar.xz"

xz -d root.tar.xz

docker import - pimachinelearning/raspi-os-lite:"$LATEST_PI_VER" < root.tar
docker import - pimachinelearning/raspi-os-lite:latest < root.tar

docker tag pimachinelearning/raspi-os-lite:"$LATEST_PI_VER" pimachinelearning/raspi-os-lite:"$LATEST_PI_VER"
docker tag pimachinelearning/raspi-os-lite:latest pimachinelearning/raspi-os-lite:latest

docker tag pimachinelearning/raspi-os-lite:"$LATEST_PI_VER" ghcr.io/pimachinelearning/pimachinelearning/pidocker:"$LATEST_PI_VER"
docker tag pimachinelearning/raspi-os-lite:latest ghcr.io/pimachinelearning/pimachinelearning/pidocker:latest

docker push pimachinelearning/raspi-os-lite:"$LATEST_PI_VER"
docker push pimachinelearning/raspi-os-lite:latest

docker push ghcr.io/pimachinelearning/pimachinelearning/pidocker:"$LATEST_PI_VER"
docker push ghcr.io/pimachinelearning/pimachinelearning/pidocker:latest

sudo umount ./mount
sudo kpartx -d "$LATEST_PI_VER-raspios-bullseye-armhf-lite.img"
rm -rf ./mount
rm "$LATEST_PI_VER"-raspios-bullseye-armhf-lite.img
