# Proprietary Blobs Audit — TECNO POVA 6 Pro 5G (LI9)

- **Firmware Base:** `HiOS 15.1.2.170SP05`
- **Firmware Build:** `OP001PF001AZ`
- **Device:** `TECNO POVA 6 Pro 5G (LI9)`

Every blob listed in `proprietary-files.txt` was programmatically cross-checked against the extracted EROFS filesystem tables of `super.img` (`vendor_a`, `vendor_dlkm_a`, `system_dlkm_a`, `system_ext_a`) from the verified `OP001PF001AZ` firmware package. Transsion factory-test, telemetry, analytics, and carrier/preloaded-app bloatware were intentionally excluded.

## Summary by Subsystem

| Subsystem | Source Partition | Blob Count | Total Size (MiB) | Purpose & Key Dependencies | Required | Available in Firmware |
| :--- | :--- | ---: | ---: | :--- | :---: | :---: |
| Audio | `vendor` | 297 | 49.41 | Audio HAL (AIDL), MT6359P / Awinic AW87xxx SmartPA tuning, Dolby Atmos DAX3, SoundTrigger | Yes | Yes (100%) |
| Biometrics (Optical Fingerprint & Face) | `vendor` | 12 | 1.88 | Under-display optical Goodix fingerprint HAL/libraries & Face AIDL HAL | Yes | Yes (100%) |
| Bluetooth | `vendor` | 40 | 5.27 | MediaTek Connsys Bluetooth AIDL HAL, BT Audio AIDL, BT firmware config | Yes | Yes (100%) |
| Camera & ISP | `vendor` | 176 | 93.47 | MT6833 Camera Provider AIDL v3, ISP HAL, S5KHM2SP (108MP) & GC32E1 (32MP) tuning/SIQ assets | Yes | Yes (100%) |
| Display, Graphics & Vulkan (Mali-G57) | `vendor` | 70 | 105.59 | HWC3 (composer 3.3), Gralloc Allocator V2 / Mapper 5.0, ARM Mali Valhall EGL/Vulkan/OpenCL, PQ AIDL | Yes | Yes (100%) |
| DRM (Widevine L1 & ClearKey) | `vendor` | 9 | 6.44 | Widevine L1 non-updatable APEX, ClearKey AIDL HAL, Secure Video Path (SVP) | Yes | Yes (100%) |
| Gatekeeper, KeyMint & Trustonic TEE | `vendor` | 63 | 14.50 | Trustonic TEE daemon, mcRegistry trustlets, KeyMint 3.0 & Gatekeeper AIDL HALs | Yes | Yes (100%) |
| GNSS / GPS | `vendor` | 35 | 11.74 | MediaTek GNSS AIDL v4, MNLD, AGPS, LBS service & GNSS configs | Yes | Yes (100%) |
| Haptics, IR Blaster & RGB LED | `vendor` | 18 | 1.05 | FourSemi FS3001 LRA haptics HAL/firmware, PWM IR blaster HAL, Awinic AW20216 LED firmware & lighteffect | Yes | Yes (100%) |
| Media Codec2 & Video Hardware Acceleration | `vendor` | 18 | 9.63 | MediaTek Codec2 AIDL video/audio decoders & encoders (HEVC/AVC/VP9/AV1) | Yes | Yes (100%) |
| Neural Networks (APU / NeuroPilot) | `vendor` | 9 | 1.30 | MediaTek Neuron AIDL shim & APUware libraries | Yes | Yes (100%) |
| NFC (NXP PN560) | `vendor` | 6 | 0.62 | NXP PN560 AIDL NFC HAL & Secure Element libraries | Yes | Yes (100%) |
| Power, Performance, Thermal & Charging | `vendor` | 26 | 1.24 | MediaTek Power AIDL v5, Thermal AIDL v2, Fuelgauge daemon, Health AIDL v3, TranCharge HAL | Yes | Yes (100%) |
| Radio, RIL, Modem, IMS & NVRAM | `vendor` | 346 | 11.85 | MT6833 5G/LTE Fusion RIL (DSDS AIDL), CCCI modem init/RPC, NVRAM daemon, VTService, NetdAgent, TetherOffload | Yes | Yes (100%) |
| Sensors (SCP MultiHAL) | `vendor` | 11 | 1.40 | Android Sensors AIDL v2 MultiHAL & MediaTek MT6833 SCP sub-HAL | Yes | Yes (100%) |
| Touchscreen & USB | `vendor` | 4 | 0.46 | FocalTech FT3683G touch firmware, USB/USB-Gadget AIDL HALs | Yes | Yes (100%) |
| Wi-Fi & Connsys Connectivity | `vendor` | 11 | 6.74 | MediaTek Gen4m MT6833 Wi-Fi AIDL HAL, hostapd/wpa_supplicant, WMT/Connsys firmware & loader | Yes | Yes (100%) |
| Vendor HAL Init Scripts & VINTF Fragments | `vendor` | 124 | 0.12 | Service startup `.rc` files and VINTF XML manifest fragments for proprietary HALs | Yes | Yes (100%) |
| Vendor DLKM Kernel Modules (MT6833 / LI9) | `vendor_dlkm` | 182 | 34.99 | Out-of-tree MediaTek & LI9 hardware `.ko` modules + `modules.load`/`.dep` for GKI 6.6.102 | Yes (with prebuilt GKI kernel) | Yes (100%) |
| System DLKM Kernel Modules (GKI 6.6.102) | `system_dlkm` | 81 | 10.41 | GKI 6.6.102 loadable kernel modules (`bluetooth.ko`, `zram.ko`, etc.) + `modules.load` | Yes (with prebuilt GKI kernel) | Yes (100%) |
| System_ext MediaTek Telephony / IMS / OTA Utilities | `system_ext` | 19 | 2.82 | `mtk_plpath_utils` (A/B preloader mapper) and MediaTek IMS/Telephony framework libraries | Yes (for A/B OTA & VoLTE/IMS) | Yes (100%) |

**Total verified proprietary blobs:** `1557` files across `vendor`, `vendor_dlkm`, `system_dlkm`, and `system_ext`.

## Representative Core Blob Mapping (Source -> Destination)

| Source Path (Firmware) | Destination Path (Device) | Partition | Function | Dependency Notes | Required | Verified |
| :--- | :--- | :--- | :--- | :--- | :---: | :---: |
| `vendor/bin/hw/android.hardware.audio.service-aidl.mediatek` | `/vendor/bin/hw/android.hardware.audio.service-aidl.mediatek` | `vendor` | AIDL v2 Audio HAL service | `audio.primary.mt6833.so`, `etc/audio_param/*`, `aw87xxx_acf.bin` | Yes | Yes |
| `vendor/bin/hw/android.hardware.biometrics.fingerprint-service` | `/vendor/bin/hw/android.hardware.biometrics.fingerprint-service` | `vendor` | Optical UDFPS AIDL v3 HAL | `gf_fingerprint.default.so`, `/dev/goodix_fp`, `tran_fp.ko` | Yes | Yes |
| `vendor/bin/hw/android.hardware.bluetooth-service-mediatek` | `/vendor/bin/hw/android.hardware.bluetooth-service-mediatek` | `vendor` | MediaTek Bluetooth AIDL HAL | `bt_drv_connac1x.ko`, `firmware/BT_FW.cfg`, `/dev/stpbt` | Yes | Yes |
| `vendor/bin/hw/android.hardware.boot-service.mtk` | `/vendor/bin/hw/android.hardware.boot-service.mtk` | `vendor` | A/B Boot Control AIDL HAL | `/dev/block/by-name/misc`, `para` | Yes | Yes |
| `vendor/bin/hw/camerahalserver` | `/vendor/bin/hw/camerahalserver` | `vendor` | Camera Provider AIDL v3 HAL | `libmtkcam*`, `etc/anc_siq/*` (S5KHM2SP + GC32E1), ISP modules | Yes | Yes |
| `vendor/bin/hw/android.hardware.graphics.composer@3.3-service` | `/vendor/bin/hw/android.hardware.graphics.composer@3.3-service` | `vendor` | HWC3 (v3.3) Display Composer | `hwcomposer.mt6833.so`, `mediatek-drm.ko`, `nt37703a` panel driver | Yes | Yes |
| `vendor/lib64/egl/libGLES_mali.so` (or `libGLES_meow.so` / `vulkan.mali.so`) | `/vendor/lib64/hw/vulkan.mali.so` | `vendor` | ARM Mali-G57 Valhall GPU Vulkan/EGL | `mali_kbase` kernel module, `/dev/mali0` | Yes | Yes |
| `vendor/apex/com.google.android.widevine.nonupdatable.apex` | `/vendor/apex/com.google.android.widevine.nonupdatable.apex` | `vendor` | Widevine L1 DRM APEX | `/dev/drm_wv`, Trustonic TEE | Yes | Yes |
| `vendor/bin/hw/android.hardware.security.keymint@3.0-service.trustonic_norkp` | `/vendor/bin/hw/android.hardware.security.keymint@3.0-service.trustonic_norkp` | `vendor` | KeyMint 3.0 AIDL HAL | `mcDriverDaemon`, `app/mcRegistry/*`, `tee.img` | Yes | Yes |
| `vendor/bin/hw/android.hardware.gatekeeper-service.trustonic` | `/vendor/bin/hw/android.hardware.gatekeeper-service.trustonic` | `vendor` | Gatekeeper AIDL HAL | `mcDriverDaemon`, `app/mcRegistry/*` | Yes | Yes |
| `vendor/bin/hw/android.hardware.gnss-service.mediatek` | `/vendor/bin/hw/android.hardware.gnss-service.mediatek` | `vendor` | GNSS AIDL v4 HAL | `mnld`, `gnss_daemon`, `gps_drv_stp.ko`, `etc/gnss/*` | Yes | Yes |
| `vendor/bin/hw/android.hardware.ir-service.example` | `/vendor/bin/hw/android.hardware.ir-service.example` | `vendor` | Consumer IR Blaster AIDL HAL | `consumerir.common.so`, `mtk_irtx_pwm.ko`, `/dev/lirc0` | Yes | Yes |
| `vendor/bin/hw/android.hardware.nfc-service.nxp_v` | `/vendor/bin/hw/android.hardware.nfc-service.nxp_v` | `vendor` | NXP PN560 NFC AIDL HAL | `nfc_i2c.ko`, `/dev/pn553`, `libnfc-nci.conf`, `libnfc-nxp.conf` | Yes | Yes |
| `vendor/bin/hw/android.hardware.sensors-service.multihal` | `/vendor/bin/hw/android.hardware.sensors-service.multihal` | `vendor` | Sensors AIDL v2 MultiHAL | `android.hardware.sensors@2.X-subhal-mediatek.so`, `scp.img`, `/dev/hf_manager` | Yes | Yes |
| `vendor/bin/hw/android.hardware.vibrator-service.mediatek` | `/vendor/bin/hw/android.hardware.vibrator-service.mediatek` | `vendor` | Vibrator AIDL v2 HAL | `haptic_fs_core.default.so`, `fs3xxx_haptic.ko`, `firmware/fs3001*.bin` | Yes | Yes |
| `vendor/bin/hw/mtkfusionrild` | `/vendor/bin/hw/mtkfusionrild` | `vendor` | 5G/LTE DSDS Fusion RIL (AIDL) | `ccci_mdinit`, `md1img.img`, `nvram_daemon`, `/dev/ccci*` | Yes | Yes |
| `vendor/bin/hw/android.hardware.wifi-service-lazy` | `/vendor/bin/hw/android.hardware.wifi-service-lazy` | `vendor` | Wi-Fi AIDL v2 HAL | `wlan_drv_gen4m_6833.ko`, `firmware/WIFI_RAM_CODE_soc2_2_*`, `wmt_loader` | Yes | Yes |
| `vendor/firmware/focaltech_ts_fw.bin` | `/vendor/firmware/focaltech_ts_fw.bin` | `vendor` | FocalTech FT3683G touch firmware | `focaltech_ft3683g.ko` | Yes | Yes |
| `vendor/firmware/aw20216_all_rgb_on.bin` | `/vendor/firmware/aw20216_all_rgb_on.bin` | `vendor` | Awinic AW20216 dynamic RGB LED config | `leds-aw20216.ko`, `bin/lighteffect` | Optional | Yes |
| `vendor_dlkm/lib/modules/*.ko` | `/vendor_dlkm/lib/modules/*.ko` | `vendor_dlkm` | 158 MT6833/LI9 out-of-tree kernel modules | Must match GKI `6.6.102-android15-8` ABI (`vermagic`) | Yes | Yes |
| `system_dlkm/lib/modules/*.ko` | `/system_dlkm/lib/modules/*.ko` | `system_dlkm` | 78 GKI 6.6.102 loadable kernel modules | Must match GKI `6.6.102-android15-8` ABI | Yes | Yes |

## Excluded Firmware Components (Intentional)

- `tr_preload` (1.46 GiB preloaded partner APKs), `tr_product` branding overlays, `tr_theme`, `tr_region`, `tr_carrier`, `tr_company`, `tr_overlayfs`
- Transsion telemetry, diagnostics, and factory-test daemons (`trancare`, `tranlog`, `trandatacenter`, `tranfac`, `tne`, `aee_aed`, `meta_tst`)
- Unrelated Goodix/Novatek/Himax/Omnivision touch firmware binaries shipped in generic MTK vendor trees (`gt9886_*`, `gt9896s_*`, etc. — LI9 uses FocalTech FT3683G as proven by DTBO and `modules.load.recovery`)
- Text configs and manifests already maintained as source in `android_device_tecno_li9/configs/` and `rootdir/`
- Binary partition images (`boot.img`, `vendor_boot.img`, `dtbo.img`, `super.img`, `md1img.img`, `preloader_li9_h335.bin`) — never committed to Git
