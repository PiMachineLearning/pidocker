#!/usr/bin/env bash

rm -f ./*.img
rm -f ./*.xz
sudo umount ./mount 
rm -rf mount

wget "https://downloads.raspberrypi.org/raspios_lite_armhf/root.tar.xz"

xz -d root.tar.xz

LATEST_PI_VER=$(curl https://downloads.raspberrypi.org/raspios_lite_armhf/os.json | jq -r '.["release_date"]')

docker import - pimachinelearning/raspi-os-lite:"$LATEST_PI_VER" < root.tar
docker import - pimachinelearning/raspi-os-lite:latest < root.tar

docker tag pimachinelearning/raspi-os-lite:"$LATEST_PI_VER" pimachinelearning/raspi-os-lite:"$LATEST_PI_VER"
docker tag pimachinelearning/raspi-os-lite:latest pimachinelearning/raspi-os-lite:latest

docker push pimachinelearning/raspi-os-lite:"$LATEST_PI_VER"
docker push pimachinelearning/raspi-os-lite:latest


rm -f root.tar.xz
