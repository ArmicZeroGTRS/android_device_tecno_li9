#
# Copyright (C) 2026 The Android Open Source Project
#
# SPDX-License-Identifier: Apache-2.0
#
# Board configuration for TECNO POVA 6 Pro 5G (LI9)
# Firmware Base:  HiOS 15.1.2.170SP05
# Firmware Build: OP001PF001AZ
# Platform:       MediaTek MT6833 (Dimensity 6080)
#

DEVICE_PATH := device/tecno/li9

# Architecture (verified from vendor/build.prop & dtb_0.dts: 6x Cortex-A55 + 2x Cortex-A76)
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-2a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := cortex-a55

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-2a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := cortex-a55

# Platform & Bootloader (verified from MT6833_Android_scatter.txt & vendor/build.prop)
TARGET_BOARD_PLATFORM := mt6833
TARGET_BOOTLOADER_BOARD_NAME := TECNO-LI9
TARGET_NO_BOOTLOADER := true
TARGET_NO_RADIOIMAGE := true

# A/B & Virtual A/B (verified from super.img LP v10.2 & vendor/build.prop)
AB_OTA_UPDATER := true
AB_OTA_PARTITIONS += \
    boot \
    dtbo \
    odm_dlkm \
    product \
    system \
    system_dlkm \
    system_ext \
    vbmeta \
    vbmeta_system \
    vbmeta_vendor \
    vendor \
    vendor_boot \
    vendor_dlkm

# Boot / Vendor Boot / DTBO Header v4 (verified from boot.img, vendor_boot.img, dtbo.img)
BOARD_BOOT_HEADER_VERSION := 4
BOARD_KERNEL_PAGESIZE := 4096
BOARD_KERNEL_BASE := 0x40000000
BOARD_KERNEL_OFFSET := 0x00080000
BOARD_RAMDISK_OFFSET := 0x11100000
BOARD_KERNEL_TAGS_OFFSET := 0x07c80000
BOARD_DTB_OFFSET := 0x07c80000

# vendor_boot.img cmdline (boot.img cmdline is empty; DTB /chosen provides remaining bootargs)
BOARD_KERNEL_CMDLINE := bootopt=64S3,32N2,64N2

BOARD_MKBOOTIMG_ARGS := \
    --header_version $(BOARD_BOOT_HEADER_VERSION) \
    --pagesize $(BOARD_KERNEL_PAGESIZE) \
    --base $(BOARD_KERNEL_BASE) \
    --kernel_offset $(BOARD_KERNEL_OFFSET) \
    --ramdisk_offset $(BOARD_RAMDISK_OFFSET) \
    --tags_offset $(BOARD_KERNEL_TAGS_OFFSET) \
    --dtb_offset $(BOARD_DTB_OFFSET)

BOARD_INCLUDE_DTB_IN_BOOTIMG := true
BOARD_USES_METADATA_PARTITION := true
BOARD_MOVE_RECOVERY_RESOURCES_TO_VENDOR_BOOT := true
BOARD_INCLUDE_RECOVERY_RAMDISK_IN_VENDOR_BOOT := true
BOARD_USES_RECOVERY_AS_BOOT := false

# Kernel (GKI 6.6.102-android15-8 ARM64, gzip-compressed Image.gz)
# Note: Kernel source for LI9 (MT6833, 6.6.102) is not shipped in stock firmware.
# Prebuilt kernel/DTB/DTBO artifacts are expected in a separate kernel repository
# (android_kernel_tecno_li9 / device/tecno/li9-kernel) when integrating into a ROM tree.
BOARD_KERNEL_IMAGE_NAME := Image.gz
TARGET_KERNEL_ARCH := arm64
TARGET_KERNEL_HEADER_ARCH := arm64
BOARD_PREBUILT_DTBOIMAGE := device/tecno/li9-kernel/dtbo.img
BOARD_PREBUILT_DTBIMAGE_DIR := device/tecno/li9-kernel/dtb
TARGET_PREBUILT_KERNEL := device/tecno/li9-kernel/Image.gz

# Kernel Modules (verified from vendor_boot PLATFORM ramdisk & vendor_dlkm / system_dlkm)
# Note: First-stage/init module loading uses /vendor/etc/init.insmod.mt6833.cfg (modprobe|*)
# via init.mtkgki.rc; stock module load lists (178 vendor_boot, 158 vendor_dlkm, 78 system_dlkm)
# belong with prebuilt kernel modules in device/tecno/li9-kernel.
BOARD_USES_GENERIC_KERNEL_IMAGE := true

# Partition Sizes (exact byte values from MT6833_Android_scatter.txt & super.img LP v10.2)
BOARD_FLASH_BLOCK_SIZE := 262144
BOARD_BOOTIMAGE_PARTITION_SIZE := 41943040
BOARD_VENDOR_BOOTIMAGE_PARTITION_SIZE := 67108864
BOARD_DTBOIMG_PARTITION_SIZE := 8388608
BOARD_USERDATAIMAGE_PARTITION_SIZE := 3221225472

# Dynamic Partitions (verified from super.img & Open/super.img LP v10.2 metadata)
BOARD_SUPER_PARTITION_SIZE := 10276044800
BOARD_SUPER_PARTITION_GROUPS := main
BOARD_MAIN_SIZE := 10273947648
BOARD_MAIN_PARTITION_LIST := \
    odm_dlkm \
    product \
    system \
    system_dlkm \
    system_ext \
    vendor \
    vendor_dlkm

# Filesystems (verified from super.img EROFS superblocks & fstab.mt6833)
BOARD_EROFS_COMPRESSOR := lz4
BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_SYSTEM_EXTIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_PRODUCTIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_VENDOR_DLKMIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_ODM_DLKMIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_SYSTEM_DLKMIMAGE_FILE_SYSTEM_TYPE := erofs
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := f2fs
TARGET_USERIMAGES_USE_F2FS := true
TARGET_USERIMAGES_USE_EXT4 := true

TARGET_COPY_OUT_VENDOR := vendor
TARGET_COPY_OUT_PRODUCT := product
TARGET_COPY_OUT_SYSTEM_EXT := system_ext
TARGET_COPY_OUT_VENDOR_DLKM := vendor_dlkm
TARGET_COPY_OUT_ODM_DLKM := odm_dlkm
TARGET_COPY_OUT_SYSTEM_DLKM := system_dlkm

# Verified Boot / AVB v2 (verified from vbmeta.img, Open/vbmeta.img, vbmeta_system.img, vbmeta_vendor.img)
BOARD_AVB_ENABLE := true
BOARD_AVB_ALGORITHM := SHA256_RSA2048
BOARD_AVB_KEY_PATH := external/avb/test/data/testkey_rsa2048.pem
BOARD_AVB_ROLLBACK_INDEX := 0
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --flags 0

BOARD_AVB_BOOT_KEY_PATH := external/avb/test/data/testkey_rsa2048.pem
BOARD_AVB_BOOT_ALGORITHM := SHA256_RSA2048
BOARD_AVB_BOOT_ROLLBACK_INDEX := 0
BOARD_AVB_BOOT_ROLLBACK_INDEX_LOCATION := 3

BOARD_AVB_VBMETA_SYSTEM := system
BOARD_AVB_VBMETA_SYSTEM_KEY_PATH := external/avb/test/data/testkey_rsa2048.pem
BOARD_AVB_VBMETA_SYSTEM_ALGORITHM := SHA256_RSA2048
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX := 0
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX_LOCATION := 2

BOARD_AVB_VBMETA_VENDOR := vendor
BOARD_AVB_VBMETA_VENDOR_KEY_PATH := external/avb/test/data/testkey_rsa2048.pem
BOARD_AVB_VBMETA_VENDOR_ALGORITHM := SHA256_RSA2048
BOARD_AVB_VBMETA_VENDOR_ROLLBACK_INDEX := 0
BOARD_AVB_VBMETA_VENDOR_ROLLBACK_INDEX_LOCATION := 4

# Recovery (verified from vendor_boot RECOVERY ramdisk: RGBX_8888, fstab.mt6833)
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/rootdir/etc/fstab.mt6833
TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888
BOARD_USES_FULL_RECOVERY_IMAGE := false

# Display & Graphics (NT37703A FHD+ 1080x2436 120Hz AMOLED, Mali-G57 Valhall, Vulkan 1.3)
TARGET_SCREEN_DENSITY := 440
TARGET_USES_VULKAN := true
TARGET_USES_HWC2 := true
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3

# Properties (verified from vendor/build.prop, system/build.prop, product/etc/build.prop)
TARGET_VENDOR_PROP += $(DEVICE_PATH)/vendor.prop
TARGET_SYSTEM_PROP += $(DEVICE_PATH)/system.prop
TARGET_PRODUCT_PROP += $(DEVICE_PATH)/product.prop

# API Levels & VINTF (verified from vendor/build.prop & vendor/etc/vintf/manifest.xml)
# Device shipped with Android 14 (first_api_level=34); MT6833 GRF board API frozen at 30;
# Stock HiOS 15.1.2.170SP05 targets Android 15 (SDK 35, VINTF 202404, SEPolicy 202404).
PRODUCT_SHIPPING_API_LEVEL := 34
BOARD_API_LEVEL := 30
BOARD_SHIPPING_API_LEVEL := 30
DEVICE_MANIFEST_FILE := $(DEVICE_PATH)/configs/vintf/manifest.xml
DEVICE_MATRIX_FILE := $(DEVICE_PATH)/configs/vintf/compatibility_matrix.xml
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE := $(DEVICE_PATH)/configs/vintf/framework_compatibility_matrix.xml

# SELinux (enforcing target — stock plat_sepolicy_vers.txt = 202404)
BOARD_VENDOR_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/vendor
SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/private
SYSTEM_EXT_PUBLIC_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/public

# Releasetools
TARGET_RELEASETOOLS_EXTENSIONS := $(DEVICE_PATH)/releasetools

# Inherit proprietary vendor board definitions if present
-include vendor/tecno/li9/BoardConfigVendor.mk
