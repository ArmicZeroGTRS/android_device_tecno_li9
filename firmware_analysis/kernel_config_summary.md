# Kernel Configuration & Repository Separation Analysis

- **Device:** TECNO POVA 6 Pro 5G (LI9)
- **Firmware Base:** HiOS 15.1.2.170SP05
- **Firmware Build:** OP001PF001AZ

---

## 1. Extracted GKI Kernel Summary (`boot.img`)

- **Kernel Banner:** `Linux version 6.6.102-android15-8-g1481f357a31c-ab14794947-4k`
- **Toolchain:** `Android (11368308, +pgo, +bolt, +lto, +mlgo, based on r510928) clang version 18.0.0`
- **Payload Format:** Gzip-compressed ARM64 `Image.gz` (`14,627,179` B compressed -> `36,665,856` B uncompressed)
- **Embedded Configuration:** `CONFIG_IKCONFIG=y` (`7,749` lines / `6,178` parsed `CONFIG_*` flags)
- **Kernel Source Availability:** Stock firmware contains **only** the compiled GKI `Image.gz` and out-of-tree `.ko` vendor/system modules — **no kernel source tree is included**. Verify whether Transsion/TECNO has published an open-source GPL kernel tarball for `LI9` (`MT6833`, Android 15 / 6.6) before attempting source-built kernel compilation (`UNKNOWN — NEEDS VERIFICATION`).

### Key Verified Kernel Config Options (`IKCONFIG`)

| Category | Verified Config Flags | Impact on Device Tree |
|---|---|---|
| Architecture & Pages | `CONFIG_ARM64=y`, `CONFIG_ARM64_4K_PAGES=y`, `CONFIG_LOCALVERSION="-4k"` | 4K page size; `BOARD_KERNEL_PAGESIZE := 4096` |
| Filesystems | `CONFIG_EROFS_FS=y`, `CONFIG_EROFS_FS_ZIP=y`, `CONFIG_F2FS_FS=y`, `CONFIG_F2FS_FS_SECURITY=y`, `CONFIG_F2FS_FS_COMPRESSION=y`, `CONFIG_EXT4_FS=y`, `CONFIG_OVERLAY_FS=y`, `CONFIG_INCREMENTAL_FS=y` | Matches EROFS dynamic partitions and F2FS userdata |
| Encryption & Verity | `CONFIG_FS_ENCRYPTION=y`, `CONFIG_FS_ENCRYPTION_INLINE_CRYPT=y`, `CONFIG_BLK_INLINE_ENCRYPTION=y`, `CONFIG_FS_VERITY=y`, `CONFIG_DM_VERITY=y`, `CONFIG_DM_VERITY_FEC=y`, `CONFIG_DM_SNAPSHOT=y`, `CONFIG_DM_USER=y` | Enables FBEv2 inlinecrypt, fsverity, AVB FEC, and Virtual A/B snapshots |
| Security & SELinux | `CONFIG_SECURITY_SELINUX=y`, `CONFIG_SECURITY_SELINUX_DEVELOP=y`, `CONFIG_SECURITY_SELINUX_BOOTPARAM=n` | SELinux cannot be toggled via `androidboot.selinux=permissive` bootparam on stock GKI |
| Memory & Swap | `CONFIG_ZRAM=m`, `CONFIG_ZRAM_DEF_COMP="lzo-rle"`, `CONFIG_PSI=y`, `CONFIG_LRU_GEN=y` | `init.mt6833.rc` switches `zram0` to `lz4` and enables 55% swap via `fstab.enableswap` |
| Modules | `CONFIG_MODULES=y`, `CONFIG_MODULE_SIG=y`, `CONFIG_IKHEADERS=m` | Strict GKI KMI (`6.6.102-android15-8`) module ABI compatibility required |
| IPC & Scheduling | `CONFIG_ANDROID_BINDER_IPC=y`, `CONFIG_ANDROID_BINDERFS=y`, `CONFIG_CGROUPS=y`, `CONFIG_BPF_SYSCALL=y`, `CONFIG_IO_URING=y`, `CONFIG_USERFAULTFD=y` | Full Android 15 runtime compatibility |

---

## 2. Out-of-Tree Kernel Module Inventory

Because LI9 uses Android 15 GKI (`6.6.102`), all MediaTek SoC drivers and LI9 board drivers (display, touch, charge pumps, SmartPA, fingerprint, NFC, camera, GPU, Connsys, modem) are loaded dynamically as `.ko` modules across three partitions:

| Location | Module Count | Key Modules Verified |
|---|---|---|
| `vendor_boot.img` (`PLATFORM` ramdisk `lib/modules/`) | `178` (`modules.load`) / `191` (`modules.load.recovery`) | `nt37703a_fhdp_dsi_vdo_tm_tm_120hz_li9.ko`, `focaltech_ft3683g.ko`, `mtk_disp_sec.ko`, `ufs-mediatek-mod.ko`, `mt6360-charger.ko`, `tc_hl7138.ko`, `mtk_wdt.ko`, `mediatek-drm.ko` |
| `vendor_dlkm_a/lib/modules/` | `158` (`modules.load`) | `tran_zram.ko`, `mtk_irtx_pwm.ko`, `leds-aw20216.ko`, `fs3xxx_haptic.ko`, `nfc_i2c.ko`, `tran_fp.ko`, `mali_kbase_mt6833_r49.ko`, `wlan_drv_gen4m_6833.ko`, `bt_drv_connac1x.ko`, `gps_drv_stp.ko`, `snd-soc-mt6833*.ko`, `aw87xxx_dlkm.ko` |
| `system_dlkm_a/lib/modules/` | `78` (`modules.load`) | GKI common modules (`bluetooth.ko`, `zsmalloc.ko`, `kheaders.ko`, `gzvm.ko`, `virtio_*.ko`, `usb_f_*.ko`) |

All `vendor_dlkm` and `system_dlkm` `.ko` modules were verified as matching `vermagic=6.6.102-android15-8-g1481f357a31c-ab14794947-4k` (verified via pure-Python EROFS LZ4 decompression and ELF `.modinfo` inspection).

---

## 3. Recommended Three-Repository Separation Strategy

Per modern AOSP / LineageOS GKI best practices, binary kernel artifacts and proprietary blobs are intentionally excluded from this device tree repository:

1. **`android_device_tecno_li9`** *(this repository — `device/tecno/li9`)*:
   - Pure text build rules, board configuration, init/fstab/ueventd scripts, VINTF manifests, audio/media/wifi/nfc/seccomp text configs, RRO overlays, SELinux policies, extraction tooling, and firmware forensic documentation. Zero binary blobs.
2. **`android_kernel_tecno_li9`** *(separate repository — `device/tecno/li9-kernel` or `kernel/tecno/li9`)*:
   - Holds either prebuilt stock GKI artifacts (`Image.gz`, `dtb/mt6833.dtb`, `dtbo.img`, `vendor_boot` 178 `.ko` modules + `modules.load`) extracted locally from `OP001PF001AZ`, OR a GPL source tree + MTK external module sources if released by TECNO/MediaTek.
   - `BoardConfig.mk` currently points `TARGET_PREBUILT_KERNEL`, `BOARD_PREBUILT_DTBIMAGE_DIR`, and `BOARD_PREBUILT_DTBOIMAGE` at `device/tecno/li9-kernel/`.
3. **`android_vendor_tecno_li9`** *(generated locally via `./extract-files.sh` -> `vendor/tecno/li9`)*:
   - Populated from the user's own stock `OP001PF001AZ` firmware dump or device via `extract-files.sh` + `setup-makefiles.sh`, containing all 1,557 verified blobs (`vendor/`, `vendor_dlkm/`, `system_dlkm/`, `system_ext/`).
