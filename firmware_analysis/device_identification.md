# Device Identification & Forensic Summary

- **Device:** TECNO POVA 6 Pro 5G (LI9)
- **Firmware Base:** HiOS 15.1.2.170SP05
- **Firmware Build:** OP001PF001AZ

Every property below is derived directly from binary artifacts in the local firmware package (`MT6833_Android_scatter.txt`, `boot.img`, `vendor_boot.img`, `dtbo.img`, `vbmeta*.img`, `super.img`, `Open/super.img`, `Open/vbmeta.img`, `Open/tkv.img`). Items not directly observable in the static firmware dump are explicitly marked `UNKNOWN — NEEDS VERIFICATION`.

---

## 1. Core Device & Firmware Identity

| Attribute | Verified Value | Evidence Source |
|---|---|---|
| Marketing Name | `TECNO POVA 6 Pro 5G` | `super.img:product_a/etc/build.prop` (`ro.product.product.tran.device.name.default`) |
| Manufacturer / Brand | `TECNO` | `vendor_a/build.prop`, `product_a/etc/build.prop` |
| Model | `TECNO LI9` | `vendor_a/build.prop` (`ro.product.vendor.model`) |
| Device Codename | `TECNO-LI9` (`li9` in AOSP tree) | `vendor_a/build.prop` (`ro.product.vendor.device`) |
| Product Name | `LI9-OP` | `vendor_a/build.prop`, `Open/super.img:tr_product_a/etc/build.prop` |
| Board Name | `TECNO-LI9` | `vendor_a/build.prop` (`ro.product.board`) |
| MediaTek Project / BOM | `li9_h335` / `LI9_H335_AB` | `product_a/overlay/framework-res__prd_li9_h335...apk`, `vendor_a/build.prop` |
| Hardware Revision | `UNKNOWN — NEEDS VERIFICATION` (runtime `/proc/cmdline` / `ro.boot.hwrev` not static in dump; DTBO entry reports `id=0`, `rev=0`) | `dtbo.img` header & `vendor_boot.img` |
| Firmware Display ID (Open) | `LI9-15.1.2.170SP05(OP001PF001AZ)` | `Open/tkv.img`, `Open/super.img:tr_product_a/etc/build.prop` |
| Firmware Display ID (Base) | `LI9-15.1.2.170SP05(BASE001PF001AZ)` | `tkv.img`, `super.img:product_a/etc/build.prop` (`ro.tranos.build.version=hios15.1.2.170`) |
| Android Version | Android 15 (SDK `35`) | `vendor_a/build.prop`, `system_a/system/build.prop` |
| Build ID | `AP3A.240905.015.A2` | `vendor_a/build.prop`, `vbmeta.img` descriptors |
| Security Patch Level | `2026-05-01` (OS/Vendor) / `2026-02-05` (Boot) | `vbmeta_system.img`, `vbmeta_vendor.img`, `boot.img` AVB properties |
| First Shipping API Level | `34` (Android 14) | `vendor_boot:RECOVERY/prop.default` (`ro.product.first_api_level=34`) |
| Vendor / Board API Level | `30` (MT6833 GRF, `ro.board.api_frozen=true`) | `vendor_a/build.prop` (`ro.board.api_level=30`) |
| VINTF Target Level | `202404` | `vendor_a/etc/vintf/manifest.xml` |
| Product / `system_ext` Fingerprint | `TECNO/LI9-OP/TECNO-LI9:15/AP3A.240905.015.A2/170005:user/release-keys` | `Open/vbmeta.img`, `product_a/etc/build.prop` |
| Vendor / Boot / DLKM Fingerprint | `TECNO/LI9-OP/TECNO-LI9:15/AP3A.240905.015.A2/260421V1373:user/release-keys` | `vbmeta_vendor.img`, `vendor_a/build.prop` |
| System (TSSI) Fingerprint | `TECNO/TSSI/FULL-64-ARMV82:15/AP3A.240905.015.A2/260421V1228:user/release-keys` | `vbmeta_system.img`, `system_a/system/build.prop` |

---

## 2. SoC, Kernel & Hardware Architecture

| Attribute | Verified Value | Evidence Source |
|---|---|---|
| SoC Marketing Name | MediaTek Dimensity 6080 | `product_a` / `TranSettingsApkResOverlay.apk` (`cpu_rate_cores="Dimensity 6080"`) |
| Platform Identifier | `mt6833` (MT6833 / MT6833P) | `vendor_boot:dtb_0.dts` (`compatible="mediatek,MT6833"`), `MT6833_Android_scatter.txt` |
| CPU Topology | 8 cores: 6× Cortex-A55 (500–2000 MHz, capacity `0x195`) + 2× Cortex-A76 (725–2400 MHz, capacity `0x400`) | `mt6833_base.dts` `/cpus`, `product_a/etc/power_profile.xml` |
| GPU | ARM Mali-G57 Valhall (`arm,mali-valhall` @ `0x13000000`), OpenGL ES 3.2 (`196610`), Vulkan 1.3 | `mt6833_base.dts`, `vendor_a/build.prop`, `vendor_a/etc/permissions/` |
| Kernel Release | `6.6.102-android15-8-g1481f357a31c-ab14794947-4k` (GKI Android 15, Clang 18.0.0) | `boot.img` decompressed `Image` banner & `IKCONFIG` |
| Kernel Architecture | `arm64` (AArch64, 4K page size, 32-bit `armeabi-v7a` userspace ABI supported) | `boot.img` `IKCONFIG` (`CONFIG_ARM64=y`, `CONFIG_ARM64_4K_PAGES=y`), `vendor_a/build.prop` |
| Bootloader Architecture | Preloader (`preloader_li9_h335.bin`) + LK (`lk.img`, 64-bit bootopt `64S3,32N2,64N2`) + Trustonic TEE (`tee.img`) + ARM TF-A / GenieZone (`gz.img`) | `MT6833_Android_scatter.txt`, `vendor_boot.img` cmdline |
| Boot Image Header Version | Header v4 (`boot.img` + `vendor_boot.img`; `init_boot` GPT slot unpopulated) | `boot.img` (`ANDROID!`, v4), `vendor_boot.img` (`VNDRBOOT`, v4) |
| Display Panel | Novatek `NT37703A` Tianma 1080×2436 FHD+ AMOLED, 60/90/120 Hz, 440 dpi, punch-hole cutout | `li9_dtbo_0.dts` (`nt37703a,fhdp,dsi,vdo,tm,tm,li9`), `li9_framework_rro.resources.txt` |
| Touchscreen | FocalTech `FT3683G` over SPI (`focaltech,fts`, `focaltech_ft3683g.ko`, FOD & pocket support) | `li9_dtbo_0.dts`, `vendor_boot` modules |
| Battery & Charging | 6000 mAh; MT6359P gauge + MT6360 PMIC/TCPC + dual HL7138/HL7139 charge pumps (70W fast charge) | `power_profile.xml`, `mt6833_base.dts`, `li9_dtbo_0.dts` |
| Audio | MT6359P codec + dual Awinic `AW87xxx` SmartPA (`0x58`, `0x59`), Dolby Atmos (`DAX3_3.13.0.9_r1`), AIDL v2 HAL | `li9_dtbo_0.dts`, `vendor_a/etc/audio_*`, `vendor_a/etc/vintf/manifest/` |
| Cameras | Rear 108MP Samsung `S5KHM2SP` + depth/aux (`camera_main@1a`, `camera_main_two@10`); Front 32MP GalaxyCore `GC32E1` (`camera_sub@1a`); `et5904` PMIC; `ocp81375`/`aw36515` flash | `li9_dtbo_0.dts`, `vendor_a/etc/anc_siq/`, `product_a/etc/build.prop` |
| Biometrics | Goodix optical under-display fingerprint (`/dev/goodix_fp`, `gf_fingerprint.default.so`) + Face AIDL v4 | `vendor_a/etc/init/vendor.goodix.rc`, `vendor_a/etc/vintf/manifest/face-default.xml` |
| NFC | NXP `PN560` (`nxp,pn544` @ `0x28`, `/dev/pn553`, `android.hardware.nfc-service.nxp_v`) | `li9_dtbo_0.dts`, `vendor_a/etc/libnfc-nxp.conf`, `product_a/etc/build.prop` |
| Haptics / IR / RGB LED | FourSemi `FS3001` LRA (`0x34`); PWM IR blaster (`/dev/lirc0`, `mtk_irtx_pwm.ko`); Awinic `AW20216` RGB LED (`0x20`) | `li9_dtbo_0.dts`, `vendor_a/etc/init/hw/init.project.rc` |
| Connectivity & Modem | MT6833 Connsys Gen4m Wi-Fi (2.4/5 GHz), Connac1x BT, GNSS AIDL v4, 5G NR/LTE/WCDMA/GSM DSDS Fusion RIL (`MOLY_NR15_R3_MP_V228_4_P2_1`) | `mt6833_base.dts`, `vendor_a/etc/vintf/manifest.xml`, `md1img.img` |

---

## 3. Partition, Filesystem, Boot & Security Architecture

| Attribute | Verified Value | Evidence Source |
|---|---|---|
| Storage Interface | UFS (`ufshci@11270000`, `mediatek,mt8183-ufshci`); eMMC `mmc@11230000` disabled in DTB; microSD `mmc@11240000` enabled (`status="okay"`) | `mt6833_base.dts`, `MT6833_Android_scatter.txt` |
| A/B & Virtual A/B | Yes — A/B (`ro.build.ab_update=true`) with Virtual A/B Compression (`ro.virtual_ab.enabled=true`, `ro.virtual_ab.compression.enabled=true`) | `vendor_a/build.prop`, `super.img` LP v10.2 (`main_a` / `main_b`) |
| Dynamic Partitions (`super`) | `10,276,044,800` B (9,800 MiB), group `main_a`/`main_b` max `10,273,947,648` B; 15 logical partitions (`system`, `system_ext`, `product`, `vendor`, `vendor_dlkm`, `odm_dlkm`, `system_dlkm`, plus 8 `tr_*` Transsion partitions) | `super.img` & `Open/super.img` LP v10.2 metadata |
| Logical Filesystem | `EROFS` (LZ4 compacted compression, `feature_incompat=0x1`, 4096 B block size) with `ext4` fallback in fstab | `super.img` superblocks, `fstab.mt6833` |
| Userdata & Encryption | `F2FS` with hardware `inlinecrypt`, FBEv2 (`aes-256-xts:aes-256-cts:v2+inlinecrypt_optimized`), metadata encryption (`/metadata/vold/metadata_encryption`), `fsverity` | `fstab.mt6833`, `boot.img` `IKCONFIG` |
| Verified Boot (AVB) | AVB v2 (`avbtool 1.3.0`, `SHA256_RSA2048`, `flags=0`): `vbmeta` chains `boot` (loc 3), `vbmeta_system` (loc 2), `vbmeta_vendor` (loc 4); direct hash on `dtbo` & `vendor_boot`; hashtree (`sha256`, `fec_roots=2`) on logical partitions | `vbmeta.img`, `Open/vbmeta.img`, `vbmeta_system.img`, `vbmeta_vendor.img` |
| SELinux Mode | Enforcing (`CONFIG_SECURITY_SELINUX=y`, `CONFIG_SECURITY_SELINUX_BOOTPARAM=n`, `plat_sepolicy_vers.txt=202404`, precompiled CIL policy) | `boot.img` `IKCONFIG`, `vendor_a/etc/selinux/plat_sepolicy_vers.txt` |
| Init System | Android two-stage init: `vendor_boot` `PLATFORM` ramdisk (`fstab.mt6833`, 178 `.ko`) + `vendor/etc/init/hw/init.mt6833.rc` -> `init.project.rc` -> `init.mtkgki.rc` (`init.insmod.sh` + `init.insmod.mt6833.cfg`) | `vendor_boot.img`, `vendor_a/etc/init/hw/` |
| Factory RAM / Storage SKUs | `UNKNOWN — NEEDS VERIFICATION` (runtime DRAM size is passed by preloader/LK via ATAG/DTB `/memory`; static base DTB reports placeholder `0x3e605000` ~998 MiB) | `mt6833_base.dts` `/memory` |
