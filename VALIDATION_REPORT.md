# Validation Report — `android_device_tecno_li9`

- **Device:** TECNO POVA 6 Pro 5G (LI9)
- **Firmware Base:** HiOS 15.1.2.170SP05
- **Firmware Build:** OP001PF001AZ
- **Validation Scope:** Static syntax, structural consistency, cross-file reference resolution, shell execution sandbox tests, firmware blob provenance verification, and repository hygiene/security audit.

---

## 1. Validation Matrix

| Category | Check | Status | Evidence / Result |
|---|---|---|---|
| **Shell Scripts** | LF line endings (`extract-files.sh`, `setup-makefiles.sh`) | **PASS** | Clean LF (`\n`), zero CRLF |
| **Shell Scripts** | Syntax check (`sh -n` on `extract-files.sh`, `setup-makefiles.sh`) | **PASS** | Exit code `0` on both scripts |
| **Shell Scripts** | Functional execution: `setup-makefiles.sh --output <tmp>` | **PASS** | Exit `0`; generated `Android.bp`, `Android.mk`, `BoardConfigVendor.mk`, `li9-vendor.mk` (`1,557` entries) |
| **Shell Scripts** | Functional execution: `extract-files.sh --help` & missing-source guard | **PASS** | Exit `0` on `--help`; safe exit `1` on missing source dir |
| **Shell Scripts** | Functional execution: `extract-files.sh --dry-run` over all 1,557 blobs | **PASS** | Cleanly parses all `1,557` lines, reports exact missing count, never writes files |
| **XML Configs** | Well-formedness across all XML files (`configs/`, `overlay/`) | **PASS** | `27/27` XML files parsed with zero errors |
| **XML Configs** | `configs/media/*.xml` `<Include href="...">` target resolution | **PASS** | All active local includes resolve cleanly (`media_codecs_google_audio.xml`, `media_codecs_dolby_audio.xml`) |
| **JSON Configs** | Strict RFC 8259 JSON validity (`cgroups.json`, `task_profiles.json`) | **PASS** | `2/2` valid after fixing stock trailing comma in `configs/cgroups.json` |
| **Python** | AST syntax check (`releasetools/releasetools.py`) | **PASS** | `1/1` valid Python 3 syntax |
| **Soong (`Android.bp`)** | Balanced syntax, unique module names, `src` path existence | **PASS** | `6` files, `19` modules — all `src` paths exist and map to `device.mk` |
| **Makefiles (`*.mk`)** | Balanced conditionals, continuation syntax, local path resolution | **PASS** | `5` files (`Android.mk`, `AndroidProducts.mk`, `BoardConfig.mk`, `device.mk`, `lineage_li9.mk`) — all local refs verified |
| **Init Scripts (`*.rc`)** | `/vendor/etc/init/hw/*.rc` `import` target resolution | **PASS** | `12/12` init scripts — every imported `.rc` exists in `rootdir/etc/` and `rootdir/Android.bp` |
| **SELinux** | Enforcing compliance (zero `permissive` statements) & context syntax | **PASS** | `12/12` files under `sepolicy/` valid; zero permissive domains |
| **Proprietary Blobs** | `proprietary-files.txt` 100% presence against `OP001PF001AZ` | **PASS** | `1,557/1,557` entries verified in stock partition file lists; `0` duplicates, `0` missing |
| **Device Tree Sources** | Structural sanity of decompiled `mt6833_base.dts` & `li9_dtbo_0.dts` | **PASS** | `/dts-v1/;` header present, balanced braces on both files |
| **Security & Hygiene** | Zero binaries, dumps, keys, secrets, placeholders, broken symlinks, >1 MiB files | **PASS** | Largest file: `firmware_analysis/device_tree/mt6833_base.dts` (`240,033` B) |
| **Firmware Alignment** | Strict `HiOS 15.1.2.170SP05` / `OP001PF001AZ` / `LI9` provenance | **PASS** | Verified across build files, blob list, and all analysis reports |
| **Android Build** | Full AOSP / LineageOS 22 (Android 15) ROM compilation | **NOT TESTED** | No Android source tree on host workstation |
| **SELinux Compile** | `checkpolicy` / `secilc` compilation against AOSP `plat_sepolicy` | **NOT TESTED** | Requires full AOSP Android 15 source tree (`system/sepolicy`) |
| **Device Boot & Runtime** | Flashing & testing boot, display, touch, RIL, Wi-Fi, BT, NFC, camera, UDFPS, 70W charging | **NOT TESTED** | Static firmware engineering only; no physical device flashed |
| **ADB Blob Pull** | Live `extract-files.sh adb` pull from physical LI9 | **NOT TESTED** | No physical LI9 connected via ADB |

---

## 2. Issues Caught & Resolved During Validation

1. **Stock `configs/cgroups.json` trailing comma:** Stock MediaTek `vendor/etc/cgroups.json` contained a trailing comma after the `"Cgroups"` array (`],`), failing strict JSON parsers. Fixed to valid RFC 8259 JSON.
2. **`BoardConfig.mk` `BOARD_VENDOR_KERNEL_MODULES_LOAD`:** Removed an incorrect `cat init.insmod.mt6833.cfg` assignment (stock `init.insmod.mt6833.cfg` uses `modprobe|*` directives for `init.insmod.sh`, not a `.ko` filename list).
3. **`device.mk` proprietary HAL packages:** Removed two MediaTek binary HAL names (`android.hardware.boot-service.mtk`, `android.hardware.audio.service-aidl.mediatek`) from `PRODUCT_PACKAGES` because they are delivered as extracted vendor binaries via `proprietary-files.txt`, avoiding duplicate/missing-source build failures in AOSP/LineageOS.
4. **`configs/media/media_codecs.xml` dangling `<Include>`:** Removed reference to `media_codecs_mediatek_audio.xml`, which does not exist in stock `OP001PF001AZ` `vendor_a/etc/`.
5. **`rootdir/etc/init.mt6833.usb.rc` USB PID alignment:** Verified and corrected ConfigFS `idProduct` values directly against stock `vendor_a/etc/init/hw/init.mt6833.usb.rc` (`ptp,adb=0x200C`, `ncm=0x2067`, `ncm,adb=0x206A`, `midi,adb=0x2048`, `accessory*=0x2d00..0x2d05`).
6. **Shell script portability (`extract-files.sh`, `setup-makefiles.sh`):** Rewrote scripts in strict POSIX-compatible shell syntax and eliminated `CDPATH=` prefix that triggered a Win32 BusyBox `sh.exe` path conversion crash, enabling verified execution across both Linux `bash` and minimal POSIX `sh`.
7. **Stock comment markers:** Reworded two upstream AOSP/MTK placeholder comments in `configs/media/media_profiles_V1_0.xml` and `configs/seccomp/android.hardware.media.c2@1.2-mediatek-seccomp-policy` without altering any functional rule.

---

## 3. Recommended Next Verification Steps (In Full ROM Tree & On Device)

1. Extract prebuilt kernel artifacts (`Image.gz`, `dtb/mt6833.dtb`, `dtbo.img`, and `vendor_boot` `lib/modules/` + `modules.load`) into `device/tecno/li9-kernel/`.
2. Run `./extract-files.sh --source <extracted_OP001PF001AZ_dir>` inside an Android 15 / LineageOS 22 source tree to populate `vendor/tecno/li9/`.
3. Execute `source build/envsetup.sh && lunch lineage_li9-userdebug && m vendorimage bootimage vendorbootimage` to verify Soong/Kati parsing, VINTF check, and `secilc` SEPolicy compilation.
4. Capture `dmesg`, `logcat`, and `audit2allow` denials on an unlocked LI9 test unit to refine `sepolicy/vendor/` rules and validate UDFPS coordinates, 120 Hz panel switching, camera ISP, 5G RIL, NFC, and 70W fast charging.
