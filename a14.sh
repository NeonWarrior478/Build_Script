#!/bin/bash

# Upgrade System
sudo apt update && sudo apt upgrade -y

#Initiating RisingOS
echo "========================================================================"
echo "INITIALIZING ROM REPOSITORY"
echo "========================================================================"

repo init -u https://github.com/RisingTechOSS/android -b fourteen --git-lfs

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

rm -rf device/xiaomi/munch
rm -rf device/xiaomi/sm8250-common
rm -rf vendor/xiaomi
rm -rf kernel/xiaomi/sm8250

echo "========================================================================"
echo "DELETED DIRECTORIES SUCCESSFULLY"
echo "========================================================================"

#Clone Resources
echo "========================================================================"
echo "CLONING BASIC MUNCH RESOURCES"
echo "========================================================================"

#1. Device Tree
git clone https://github.com/Killer2801/android_device_xiaomi_munch.git -b fourteen device/xiaomi/munch

#2. Common Device Tree
git clone https://github.com/Killer2801/android_device_xiaomi_sm8250-common.git -b fourteen device/xiaomi/sm8250-common

#3. Vendor Tree
git clone https://gitea.com/deadlyshroud/vendor_xiaomi_munch.git -b fourteen vendor/xiaomi/munch

#4. Common Vendor Tree
git clone https://gitea.com/deadlyshroud/vendor_xiaomi_sm8250-common.git -b fourteen vendor/xiaomi/sm8250-common

#5. Kernel Tree
git clone https://github.com/kvsnr113/xiaomi_sm8250_kernel.git -b main kernel/xiaomi/sm8250

echo "========================================================================"
echo "BASIC MUNCH RESOURCES CLONED SUCCESSFULLY"
echo "========================================================================"

#Extra Additions
echo "========================================================================"
echo "CLONING EXTRA STUFF"
echo "========================================================================"

#1. Hardware Xiaomi
rm -rf hardware/xiaomi
git clone https://github.com/LineageOS/android_hardware_xiaomi.git -b lineage-21 hardware/xiaomi

#2. Hardware Display
rm -rf hardware/qcom-caf/sm8250/display
git clone https://github.com/hdzungx/android_hardware_qcom-caf_sm8250_display -b uqpr3 hardware/qcom-caf/sm8250/display

#3. Leica Camera
git clone https://gitea.com/hdzungx/android_vendor_xiaomi_miuicamera.git -b uqpr3 vendor/xiaomi/miuicamera

#4. KProfiles 
rm -rf packages/apps/KProfiles
git clone https://github.com/yaap/packages_apps_KProfiles.git -b fourteen packages/apps/KProfiles

#5. Prebuilt Clang
rm -rf prebuilts/clang/host/linux-x86/clang-r522817
git clone -b 14.0 https://gitlab.com/crdroidandroid/android_prebuilts_clang_host_linux-x86_clang-r522817.git prebuilts/clang/host/linux-x86/clang-r522817

echo "========================================================================"
echo "EXTRA STUFF CLONED SUCCESSFULLY"
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

#2. Pocket Mode
sed -i 's/android:minSdkVersion="19"/android:minSdkVersion="21"/' prebuilts/sdk/current/androidx/m2repository/androidx/preference/preference/1.3.0-alpha01/manifest/AndroidManifest.xml

#3. XiaomiVibrator Feature
cd frameworks/native
git fetch https://github.com/VoidUI-Tiramisu/frameworks_native refs/heads/aosp-13 && git cherry-pick d3b4026058e9d44759860c0b69d35de3f801c4e1
cd ../..

echo "========================================================================"
echo "MODIFICATIONS DONE SUCCESSFULLY"
echo "========================================================================"

#Build Commands
echo "========================================================================"
echo "BUILD STARTING"
echo "========================================================================"

source build/envsetup.sh
riseup munch userdebug
gk -s
rise b
