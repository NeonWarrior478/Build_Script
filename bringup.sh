#!/bin/bash

# Upgrade System
sudo apt update && sudo apt upgrade -y

#Initiating PixelOS
echo "========================================================================"
echo "INITIALIZING ROM REPOSITORY"
echo "========================================================================"

repo init -u https://github.com/PixelOS-AOSP/manifest.git -b fourteen --git-lfs

echo "========================================================================"
echo "ROM REPOSITORY INITIALIZED SUCCESSFULLY"
echo "========================================================================"

#Resync
echo "========================================================================"
echo "RESYNCING SOURCE"
echo "========================================================================"

/opt/crave/resync.sh

#Remove Device Resources (if any)
echo "========================================================================"
echo "DELETING DIRECTORIES"
echo "========================================================================"

rm -rf device/motorola/fogos
rm -rf device/motorola/sm6375-common
rm -rf vendor/motorola/fogos
rm -rf vendor/motorola/sm6375-common
rm -rf kernel/motorola/sm6375


echo "========================================================================"
echo "DELETED DIRECTORIES SUCCESSFULLY"
echo "========================================================================"

#Clone Resources
echo "========================================================================"
echo "CLONING BASIC MUNCH RESOURCES"
echo "========================================================================"

#1. Device Tree
git clone https://github.com/NeonWarrior478/android_device_motorola_fogos.git -b fourteen device/motorola/fogos

#2. Common Device Tree
git clone https://github.com/NeonWarrior478/android_device_motorola_sm6375-common.git -b fourteen device/motorola/sm6375-common

#3. Vendor Tree
git clone https://github.com/NeonWarrior478/proprietary_vendor_motorola_fogos.git -b fourteen vendor/motorola/fogos 

#4. Common Vendor Tree
git clone https://github.com/NeonWarrior478/proprietary_vendor_motorola_sm6375-common.git  -b fourteen vendor/motorola/sm6375-common

#5. Kernel Tree
git clone https://github.com/NeonWarrior478/android_kernel_motorola_sm6375.git  -b fourteen kernel/motorola/sm6375

#6. Camera
wget https://sourceforge.net/projects/rom-violet/files/fogos/MotCamera4.apk vendor/motorola/fogos/proprietary/product/priv-app/MotCamera4

echo "========================================================================"
echo "BASIC MUNCH RESOURCES CLONED SUCCESSFULLY"
echo "========================================================================"


#Modifications
echo "========================================================================"
echo "MODIFICATIONS STARTED"
echo "========================================================================"

#1. Neutron Clang
cd prebuilts/clang/host/linux-x86
mkdir clang-neutron
cd clang-neutron
curl -LO "https://raw.githubusercontent.com/Neutron-Toolchains/antman/main/antman"
chmod +x antman
./antman -S=05012024
./antman --patch=glibc
cd ../../../../..


echo "========================================================================"
echo "MODIFICATIONS DONE SUCCESSFULLY"
echo "========================================================================"

#Build Commands
echo "========================================================================"
echo "BUILD STARTING"
echo "========================================================================"

source build/envsetup.sh
lunch aosp_fogos-ap2a-userdebug
mka bacon
