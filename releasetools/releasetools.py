# Copyright (C) 2026 The Android Open Source Project
#
# SPDX-License-Identifier: Apache-2.0
#
# OTA releasetools extensions for TECNO POVA 6 Pro 5G (LI9 / MT6833)
# Firmware Base: HiOS 15.1.2.170SP05 (OP001PF001AZ)

import common


def FullOTA_InstallEnd(info):
    """Hook executed at the end of A/B full OTA generation.

    On Virtual A/B devices, dynamic partitions and A/B boot/dtbo/vendor_boot
    images are packaged by update_engine / brillo_update_payload directly.
    Firmware image assertions or preloader/lk OTA updates can be appended here
    once validated on hardware.
    """
    return


def IncrementalOTA_InstallEnd(info):
    """Hook executed at the end of A/B incremental OTA generation."""
    return
