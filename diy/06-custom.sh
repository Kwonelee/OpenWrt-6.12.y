#!/bin/bash -e

# 应用 GCC 补丁
curl -s $mirror/openwrt/patch/generic-24.10/202-toolchain-gcc-add-support-for-GCC-15.patch | patch -p1

# 集成设备无线
mkdir -p package/base-files/files/lib/firmware/brcm
cp -a $GITHUB_WORKSPACE/configfiles/firmware/brcm/* package/base-files/files/lib/firmware/brcm/

# 添加设备
echo -e "\\ndefine Device/firefly_station-m2
  \$(Device/rk3566)
  DEVICE_VENDOR := Firefly
  DEVICE_MODEL := Station M2 / RK3566 ROC PC
  DEVICE_DTS := rk3566-roc-pc
  SUPPORTED_DEVICES += firefly,rk3566-roc-pc firefly,station-m2
  UBOOT_DEVICE_NAME := generic-rk3568
  DEVICE_PACKAGES := kmod-nvme kmod-scsi-core kmod-r8169
endef
TARGET_DEVICES += firefly_station-m2" >> target/linux/rockchip/image/armv8.mk

sed -i '/linkease_easepi-r1 \\/a\    firefly_station-m2' package/boot/uboot-rockchip/Makefile

# 复制dts到files/arch/arm64/boot/dts/rockchip
mkdir -p target/linux/rockchip/files/arch/arm64/boot/dts/rockchip/
cp -f $GITHUB_WORKSPACE/configfiles/dts/rk3566-roc-pc.dts target/linux/rockchip/files/arch/arm64/boot/dts/rockchip/
