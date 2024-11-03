#!/bin/bash

#Removing Device Resources (if any)
echo "========================================================================"
echo "DELETING DIRECTORIES"
echo "========================================================================"

rm -rf device/xiaomi/munch
rm -rf device/xiaomi/sm8250-common
rm -rf vendor/xiaomi/munch
rm -rf vendor/xiaomi/sm8250-common
rm -rf kernel/xiaomi/sm8250
rm -rf vendor/xiaomi/miuicamera

echo "========================================================================"
echo "DELETED DIRECTORIES SUCCESSFULLY"
echo "========================================================================"

#Initiating RisingOS
echo "========================================================================"
echo "INITIALIZING ROM REPOSITORY"
echo "========================================================================"

repo init -u https://github.com/RisingTechOSS/android -b fourteen --git-lfs

echo "========================================================================"
echo "ROM REPOSITORY INITIALIZED SUCCESSFULLY"
echo "========================================================================"

#Resync Source
echo "========================================================================"
echo "RESYNCING SOURCE"
echo "========================================================================"

/opt/crave/resync.sh

echo "========================================================================"
echo "RESYNCED SOURCE SUCCESSFULLY"
echo "========================================================================"

#Clone Resources
echo "========================================================================"
echo "CLONING BASIC MUNCH RESOURCES"
echo "========================================================================"

#1. Device Tree
git clone https://github.com/DeadlyShroud/device_xiaomi_munch.git --depth=1 -b fourteen device/xiaomi/munch

#2. Common Device Tree
git clone https://github.com/DeadlyShroud/device_xiaomi_sm8250-common.git --depth=1 -b fourteen device/xiaomi/sm8250-common

#3. Vendor Tree
git clone https://gitea.com/deadlyshroud/vendor_xiaomi_munch.git --depth=1 -b fourteen vendor/xiaomi/munch

#4. Common Vendor Tree
git clone https://gitea.com/deadlyshroud/vendor_xiaomi_sm8250-common.git --depth=1 -b fourteen vendor/xiaomi/sm8250-common

#5. Kernel Tree
git clone https://github.com/kvsnr113/xiaomi_sm8250_kernel.git --depth=1 -b main kernel/xiaomi/sm8250

echo "========================================================================"
echo "BASIC MUNCH RESOURCES CLONED SUCCESSFULLY"
echo "========================================================================"

#Extra Additions
echo "========================================================================"
echo "CLONING EXTRA STUFF"
echo "========================================================================"

#1. Hardware Xiaomi
rm -rf hardware/xiaomi
git clone https://github.com/LineageOS/android_hardware_xiaomi.git --depth=1 -b lineage-21 hardware/xiaomi

#2. Hardware Display
rm -rf hardware/qcom-caf/sm8250/display
git clone https://github.com/NewbieNoob1/hardware-qcom-caf-sm8250-display.git --depth=1 -b fifteen hardware/qcom-caf/sm8250/display

#3. Leica Camera
git clone https://gitea.com/hdzungx/android_vendor_xiaomi_miuicamera.git --depth=1 -b uqpr3 vendor/xiaomi/miuicamera

#4. Viper4AndroidFX
git clone https://github.com/TogoFire/packages_apps_ViPER4AndroidFX.git --depth=1 -b v4a packages/apps/ViPER4AndroidFX

#5. KProfiles 
rm -rf packages/apps/KProfiles
git clone https://github.com/yaap/packages_apps_KProfiles.git --depth=1 -b fourteen packages/apps/KProfiles

#6. Neutron Clang
git clone https://gitea.com/Bhairav/prebuilts_clang_host_linux-x86_clang-neutron.git -b main prebuilts/clang/host/linux-x86/clang-neutron

echo "========================================================================"
echo "EXTRA STUFF CLONED SUCCESSFULLY"
echo "========================================================================"

#Modifications
echo "========================================================================"
echo "MODIFICATIONS STARTED"
echo "========================================================================"

#1. XiaomiVibrator Feature
cd frameworks/native
git fetch https://github.com/VoidUI-Tiramisu/frameworks_native refs/heads/aosp-13 && git cherry-pick d3b4026058e9d44759860c0b69d35de3f801c4e1
cd ../..

#2. Dolby
cd device/xiaomi/sm8250-common
git fetch https://github.com/crdroidandroid/android_hardware_xiaomi refs/heads/15.0 && git cherry-pick 35896433d70fda2e121979e768fb688f6c11c713
cd cd ../../..

echo "========================================================================"
echo "MODIFICATIONS DONE SUCCESSFULLY"
echo "========================================================================"

#Build
echo "========================================================================"
echo "BUILD STARTING"
echo "========================================================================"

source build/envsetup.sh
riseup munch userdebug
rise b