#
# Copyright (C) 2026 The Android Open Source Project
#
# SPDX-License-Identifier: Apache-2.0
#
# Product definition for TECNO POVA 6 Pro 5G (LI9)
# Target: Android 15 (API 35) / LineageOS 22.x compatible structure
# Firmware Base:  HiOS 15.1.2.170SP05
# Firmware Build: OP001PF001AZ
#

# Inherit standard 64-bit / 32-bit Android phone configuration
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit LineageOS common phone configuration (when built in a LineageOS 22.x tree)
$(call inherit-product-if-exists, vendor/lineage/config/common_full_phone.mk)

# Inherit TECNO LI9 device configuration
$(call inherit-product, device/tecno/li9/device.mk)

# Device & Product Identity (verified from Open/tr_product_a & vendor/build.prop)
PRODUCT_NAME := lineage_li9
PRODUCT_DEVICE := li9
PRODUCT_BRAND := TECNO
PRODUCT_MODEL := TECNO LI9
PRODUCT_MANUFACTURER := TECNO
PRODUCT_GMS_CLIENTID_BASE := android-transsion

# Build fingerprint overrides matching HiOS 15.1.2.170SP05 (OP001PF001AZ)
BUILD_FINGERPRINT := TECNO/LI9-OP/TECNO-LI9:15/AP3A.240905.015.A2/170005:user/release-keys

PRODUCT_BUILD_PROP_OVERRIDES += \
    BuildDesc="LI9-OP-user 15 AP3A.240905.015.A2 170005 release-keys" \
    BuildFingerprint=$(BUILD_FINGERPRINT) \
    DeviceName=TECNO-LI9 \
    DeviceProduct=LI9-OP \
    SystemDevice=TECNO-LI9 \
    SystemName=LI9-OP
