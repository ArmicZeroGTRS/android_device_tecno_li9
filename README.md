# Android Device Tree for TECNO POVA 6 Pro 5G (LI9)

- **Device:** TECNO POVA 6 Pro 5G (LI9)
- **Firmware Base:** HiOS 15.1.2.170SP05
- **Firmware Build:** OP001PF001AZ
- **Target Android Version:** Android 15 (SDK 35 / VINTF `202404` / SEPolicy `202404`)

> **Build & Hardware Status:** This repository is a **forensically constructed, statically validated foundation device tree** built exclusively from binary evidence extracted from stock `HiOS 15.1.2.170SP05 (OP001PF001AZ)` firmware. Full AOSP/LineageOS ROM compilation and physical device boot have **NOT** yet been tested (see [VALIDATION_REPORT.md](VALIDATION_REPORT.md)).

---

## 1. Device Overview

The **TECNO POVA 6 Pro 5G** (codename `LI9`, MediaTek board project `li9_h335`, product `LI9-OP`) is a 5G Android smartphone built on the **MediaTek Dimensity 6080 (`MT6833`)** platform, originally shipping with Android 14 (`ro.product.first_api_level=34`) and updated to Android 15 (`HiOS 15.1.2.170SP05`).

This repository provides clean, evidence-backed AOSP/LineageOS device configurations, verified hardware properties, init/fstab/ueventd scripts, VINTF manifests, RRO overlays, enforcing-compatible SELinux baseline policies, blob extraction tooling, and decompiled firmware forensic records.

---

## 2. Hardware Specifications (Verified from Stock Firmware)

| Component | Verified Specification | Firmware Evidence |
|---|---|---|
| **SoC** | MediaTek Dimensity 6080 (`MT6833` / `MT6833P`) | `mt6833_base.dts`, `TranSettingsApkResOverlay.apk` |
| **CPU** | Octa-core: 6× Cortex-A55 (500–2000 MHz) + 2× Cortex-A76 (725–2400 MHz) | `mt6833_base.dts` `/cpus`, `power_profile.xml` |
| **GPU** | ARM Mali-G57 (`arm,mali-valhall` @ `0x13000000`), OpenGL ES 3.2, Vulkan 1.3 | `mt6833_base.dts`, `vendor/build.prop` |
| **Display** | Novatek `NT37703A` Tianma 1080×2436 FHD+ (440 dpi) 60/90/120 Hz AMOLED, center punch-hole | `li9_dtbo_0.dts`, `li9_framework_rro` |
| **Touchscreen** | FocalTech `FT3683G` over SPI (`focaltech_ft3683g.ko`), 10-point, FOD & pocket mode | `li9_dtbo_0.dts` (`focaltech@0`) |
| **Storage** | UFS (`ufshci@11270000`, `mediatek,mt8183-ufshci`) + microSD (`mmc@11240000`) | `mt6833_base.dts`, `fstab.mt6833` |
| **RAM / Storage SKUs** | `UNKNOWN — NEEDS VERIFICATION` (runtime DRAM configured by preloader/LK) | Static DTB holds placeholder `/memory` |
| **Battery & Charging** | 6000 mAh (`power_profile.xml`); MT6359P gauge + MT6360 PMIC/TCPC + dual HL7138/HL7139 70W charge pumps | `power_profile.xml`, `li9_dtbo_0.dts` |
| **Audio** | MT6359P codec + dual Awinic `AW87xxx` SmartPA (`0x58`, `0x59`), Dolby Atmos (`DAX3_3.13.0.9_r1`) | `li9_dtbo_0.dts`, `vendor/etc/audio_*` |
| **Rear Cameras** | 108 MP Samsung `S5KHM2SP` + depth/aux (`et5904` PMIC, `ocp81375`/`aw36515` flash) | `li9_dtbo_0.dts`, `vendor/etc/anc_siq/` |
| **Front Camera** | 32 MP GalaxyCore `GC32E1` (`camera_sub@1a`) | `li9_dtbo_0.dts`, `product/etc/build.prop` |
| **Biometrics** | Goodix optical under-display fingerprint (`/dev/goodix_fp`) + Face AIDL v4 | `vendor.goodix.rc`, `vendor/etc/vintf/` |
| **NFC** | NXP `PN560` (`nxp,pn544` @ `0x28`, `/dev/pn553`, AIDL `android.hardware.nfc-service.nxp_v`) | `li9_dtbo_0.dts`, `libnfc-nxp.conf` |
| **Haptics** | FourSemi `FS3001` LRA (`foursemi,fshaptic` @ `0x34`, `fs3xxx_haptic.ko`) | `li9_dtbo_0.dts`, `init.project.rc` |
| **IR Blaster & RGB LED** | PWM IR transmitter (`/dev/lirc0`, `mtk_irtx_pwm.ko`); Awinic `AW20216` RGB LED (`0x20`) | `li9_dtbo_0.dts`, `init.project.rc` |
| **Connectivity** | MT6833 Connsys Gen4m Wi-Fi (2.4/5 GHz, SAE/H2E), Connac1x BT, Dual-band L1/L5 GNSS AIDL v4 | `mt6833_base.dts`, `WifiResOverlay.apk` |
| **Modem** | 5G NR / LTE / WCDMA / GSM DSDS Fusion RIL (`MOLY_NR15_R3_MP_V228_4_P2_1`) | `md1img.img`, `vendor/etc/vintf/manifest.xml` |

---

## 3. Platform & Chipset Details

- **Platform:** `mt6833` (`TARGET_BOARD_PLATFORM := mt6833`, `TARGET_BOOTLOADER_BOARD_NAME := TECNO-LI9`)
- **GRF / Vendor API:** Board API level frozen at `30` (`ro.board.api_level=30`, `ro.board.api_frozen=true`) while running Android 15 userspace (SDK `35`, VINTF target-level `202404`, SEPolicy `202404`).
- **TEE / Keystore:** Trustonic Kinibi TEE (`tee.img`, `vendor.trustonic.tee`), KeyMint v3 (`keymint-service.trustonic_norkp`), Gatekeeper, Widevine L1 DRM (`/dev/drm_wv`, vendor APEX).

---

## 4. Firmware Reference Version

All device properties, partition dimensions, AVB parameters, DTB/DTBO analyses, overlays, configs, and proprietary blob paths are strictly anchored to:

- **Firmware Base:** `HiOS 15.1.2.170SP05`
- **Firmware Build:** `OP001PF001AZ`
- **Display ID:** `LI9-15.1.2.170SP05(OP001PF001AZ)` (`Open/` overlay on `BASE001PF001AZ`)
- **Android Build ID:** `AP3A.240905.015.A2` (Android 15, Security Patch `2026-05-01`)
- **Product Fingerprint:** `TECNO/LI9-OP/TECNO-LI9:15/AP3A.240905.015.A2/170005:user/release-keys`
- **Vendor Fingerprint:** `TECNO/LI9-OP/TECNO-LI9:15/AP3A.240905.015.A2/260421V1373:user/release-keys`

---

## 5. Partition Layout Overview

Verified from `MT6833_Android_scatter.txt` and `super.img` / `Open/super.img` LP v10.2 metadata:

- **Slot Architecture:** Virtual A/B with Compression (`AB_OTA_UPDATER := true`, `vabc_features.mk`).
- **Dynamic Partition Container (`super`):** `10,276,044,800` B (9,800 MiB), group `main` max size `10,273,947,648` B.
- **Logical Partitions (EROFS LZ4):** `system`, `system_ext`, `product`, `vendor`, `vendor_dlkm`, `odm_dlkm`, `system_dlkm` (stock HiOS additionally carries 8 Transsion `tr_*` partitions omitted in AOSP builds).
- **Key Static Partitions:**
  - `boot_a/b`: `41,943,040` B (40 MiB)
  - `vendor_boot_a/b`: `67,108,864` B (64 MiB)
  - `dtbo_a/b`: `8,388,608` B (8 MiB)
  - `vbmeta_a/b`, `vbmeta_system_a/b`, `vbmeta_vendor_a/b`: `8,388,608` B (8 MiB each)
  - `metadata`: `33,554,432` B (32 MiB, `ext4`)
  - `userdata`: `F2FS` with `inlinecrypt` + FBEv2 (`aes-256-xts:aes-256-cts:v2+inlinecrypt_optimized`) + `fsverity`.

---

## 6. Boot Architecture Overview

- **Boot Header:** v4 (`BOARD_BOOT_HEADER_VERSION := 4`, `BOARD_KERNEL_PAGESIZE := 4096`).
- **Addresses & Offsets:** Base `0x40000000`, Kernel offset `0x00080000` (`0x40080000`), Ramdisk offset `0x11100000` (`0x51100000`), Tags & DTB offset `0x07c80000` (`0x47c80000`).
- **`boot.img`:** Contains GKI 6.6.102 `Image.gz` (`14,627,179` B) with **`ramdisk_size = 0`** and empty cmdline. `init_boot` GPT slots exist in scatter as `NONE` (unpopulated).
- **`vendor_boot.img`:** Contains cmdline `bootopt=64S3,32N2,64N2`, `mt6833` base DTB (`193,651` B), and two LZ4-legacy vendor ramdisks: `PLATFORM` (`fstab.mt6833` + 178 `.ko`) and `RECOVERY` (`recovery` + `fastbootd` + `init.recovery.mt6833.rc`).
- **`dtbo.img`:** DTBO v0 table with 1 entry (`67,890` B, `id=0`, `rev=0`, 73 overlay fragments).
- **AVB v2:** `SHA256_RSA2048` (`avbtool 1.3.0`), `vbmeta` chains `boot` (rollback loc 3), `vbmeta_system` (loc 2), and `vbmeta_vendor` (loc 4).

---

## 7. Kernel Status

- **Stock Kernel:** `Linux version 6.6.102-android15-8-g1481f357a31c-ab14794947-4k` (Android 15 GKI, Clang 18.0.0, 4K pages).
- **Kernel Source:** **Not included in stock firmware.** Prebuilt kernel/DTB/DTBO binaries and vendor `.ko` modules are intentionally excluded from this repository and expected in a separate kernel repository (`device/tecno/li9-kernel/`). See [firmware_analysis/kernel_config_summary.md](firmware_analysis/kernel_config_summary.md).

---

## 8. Device Tree Repository Structure

```text
android_device_tecno_li9/
├── Android.bp / Android.mk / AndroidProducts.mk
├── BoardConfig.mk / device.mk / lineage_li9.mk
├── product.prop / system.prop / vendor.prop
├── proprietary-files.txt          # 1,557 verified OP001PF001AZ blobs
├── extract-files.sh               # Local dump & ADB blob extractor
├── setup-makefiles.sh             # Generates vendor/tecno/li9 makefiles
├── configs/                       # Audio, Media, Wi-Fi, NFC, Sensors, Seccomp, VINTF
├── overlay/                       # 4 RRO packages (Framework, Wi-Fi, SystemUI, SettingsProvider)
├── rootdir/                       # Android.bp, fstab.mt6833, init.*.rc, ueventd.mt6833.rc
├── sepolicy/                      # Enforcing baseline (vendor/, private/, public/)
├── recovery/                      # recovery.fstab & vendor_boot recovery notes
├── releasetools/                  # A/B OTA releasetools extension hooks
├── firmware_analysis/             # Complete forensic inventory, DTB/DTBO DTS, audits
├── VALIDATION_REPORT.md
├── LICENSE                        # Apache License 2.0
└── README.md
```

*(Note: A local GitHub Actions workflow template `.github/workflows/validate.yml` is generated in the working directory and can be added after granting the `workflow` OAuth scope via `gh auth refresh -s workflow`.)*

---

## 9. Proprietary Blob Extraction Guide

No proprietary binaries are committed in this repository. Extract blobs from your own `HiOS 15.1.2.170SP05 (OP001PF001AZ)` firmware dump or device:

### Option A: From a Local Extracted Firmware Directory (Recommended)
Ensure the directory contains extracted `vendor/`, `vendor_dlkm/`, `system_dlkm/`, and `system_ext/` (or `*_a/` slot-suffixed equivalents):
```bash
./extract-files.sh --source /path/to/extracted_OP001PF001AZ --dry-run
./extract-files.sh --source /path/to/extracted_OP001PF001AZ
```

### Option B: From a Connected LI9 Device via ADB
```bash
./extract-files.sh adb
```

Both modes automatically invoke `./setup-makefiles.sh` to generate `vendor/tecno/li9/{Android.bp,Android.mk,BoardConfigVendor.mk,li9-vendor.mk}`.

---

## 10. Build Integration Guide (AOSP / LineageOS 22 — Android 15)

1. Place this repository at `device/tecno/li9`.
2. Populate prebuilt kernel/DTB/DTBO artifacts at `device/tecno/li9-kernel` (`Image.gz`, `dtb/`, `dtbo.img`).
3. Extract proprietary blobs into `vendor/tecno/li9` using `./extract-files.sh`.
4. Initialize the build environment and select the LI9 target:
   ```bash
   source build/envsetup.sh
   lunch lineage_li9-userdebug
   m bacon
   ```
*(Note: Full ROM compilation has not yet been executed; expect initial bringup adjustments for LineageOS common MTK dependencies, prebuilt kernel module packaging, and SEPolicy compilation.)*

---

## 11. SELinux Status

- Stock GKI 6.6.102 disables `CONFIG_SECURITY_SELINUX_BOOTPARAM` (`=n`) and ships precompiled SEPolicy `202404`.
- `sepolicy/` provides a clean **enforcing-compatible baseline** (`vendor/`, `private/`, `public/`) with **zero `permissive` domains**, covering Goodix optical fingerprint (`/dev/goodix_fp`), NXP PN560 NFC (`/dev/pn553`), PWM IR (`/dev/lirc0`), FourSemi FS3001 vibrator sysfs, Mali-G57 GPU, Widevine `/dev/drm_wv`, and `mtk_plpath_utils`.
- Additional MediaTek vendor HAL rules will be needed once compiled against `system/sepolicy` and tested with `audit2allow` on live hardware.

---

## 12. Recovery Notes

- LI9 embeds recovery inside `vendor_boot.img` (`VENDOR_RAMDISK_TYPE_RECOVERY`), using `TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888`, `ro.recovery.ui.margin_height=126`, `focaltech_ft3683g.ko` touch, and `nt37703a` AMOLED panel modules.
- See [recovery/README.md](recovery/README.md) and [recovery/recovery.fstab](recovery/recovery.fstab) for full details.

---

## 13. Known Limitations & Unverified Items

- **Full ROM compilation & Soong/Kati/SEPolicy build:** `NOT TESTED` (no local AOSP source tree).
- **Hardware boot & subsystem runtime bringup:** `NOT TESTED` (display 120 Hz, UDFPS optical HBM illumination, 108MP camera ISP, 5G RIL/IMS, NFC PN560, 70W dual-pump HL7138/HL7139 charging, Dolby Atmos, FBEv2 decryption in recovery).
- **Kernel source & `boot.img` zero-ramdisk LK behavior:** `UNKNOWN — NEEDS VERIFICATION` on physical hardware.
- **Hardware revision / RAM-storage SKU matrix:** `UNKNOWN — NEEDS VERIFICATION` (runtime-injected by bootloader).

---

## 14. Firmware Forensic Documentation

- [Firmware Inventory (Markdown)](firmware_analysis/firmware_inventory.md) & [CSV](firmware_analysis/firmware_inventory.csv)
- [Device Identification & Provenance](firmware_analysis/device_identification.md)
- [Boot Image, DTB & DTBO Analysis](firmware_analysis/device_tree/dtb_dtbo_analysis.md)
- [Decompiled Base DTB (`mt6833_base.dts`)](firmware_analysis/device_tree/mt6833_base.dts) & [Board DTBO (`li9_dtbo_0.dts`)](firmware_analysis/device_tree/li9_dtbo_0.dts)
- [Kernel Config & Repository Separation Summary](firmware_analysis/kernel_config_summary.md)
- [Proprietary Blobs Audit](firmware_analysis/proprietary_blobs_audit.md)
- [Static Validation Report](VALIDATION_REPORT.md)

---

## 15. Contribution Guidelines

1. Ground all hardware and configuration changes in verified firmware evidence, kernel logs (`dmesg`), or `logcat` / `avc: denied` outputs from LI9 hardware.
2. Never commit binary firmware dumps (`.img`, `.bin`, `.apk`, `.ko`, `.dtb`, `.dtbo`), proprietary vendor blobs, signing keys, or permissive SELinux hacks.
3. Validate XML/JSON/Makefiles/Android.bp/shell syntax cleanly on all pull requests before merging.

---

## 16. Disclaimer & License

This repository is provided for independent Android custom ROM development and hardware research **as-is, without warranty**. Unlocking bootloaders and flashing custom firmware carries inherent risk of data loss or device bricking.

Device tree configuration files and scripts are licensed under the **Apache License 2.0** (see [LICENSE](LICENSE)). All trademarks belong to their respective owners (TECNO / Transsion, MediaTek, ARM, Google).
