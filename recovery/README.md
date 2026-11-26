# Recovery Architecture Notes — TECNO POVA 6 Pro 5G (LI9)

Verified from stock `vendor_boot.img` (`HiOS 15.1.2.170SP05` / `OP001PF001AZ`):

- **Architecture:** Boot Header v4 with `recovery` embedded as Vendor Ramdisk #1 (`VENDOR_RAMDISK_TYPE_RECOVERY`, name `recovery`, LZ4-legacy compressed) inside `vendor_boot.img` (64 MiB). There is no standalone `recovery` partition in `MT6833_Android_scatter.txt`.
- **Display & Graphics:** `TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888`, panel `nt37703a_fhdp_dsi_vdo_tm_tm_120hz_li9.ko` (1080x2436), UI top margin `ro.recovery.ui.margin_height=126` (accounts for punch-hole cutout).
- **Touchscreen:** FocalTech `FT3683G` (`focaltech_ft3683g.ko`, firmware `focaltech_ts_fw.bin`). Note that `vendor_boot` `PLATFORM` ramdisk contains 191 modules in `modules.load.recovery`, including panel and touch modules required for recovery UI interaction.
- **USB / Fastbootd:** Controller `musb-hdrc`, ConfigFS enabled, stock recovery USB VID `18D1`, ADB PID `D001`, Fastboot PID `4EE0`, `fastbootd` supported via `/system/bin/fastbootd`.
- **Encryption:** FBEv2 + inlinecrypt + metadata encryption (`/metadata/vold/metadata_encryption`, `aes-256-xts:aes-256-cts:v2+inlinecrypt_optimized`). Custom recovery decryption requires matching Trustonic KeyMint v3 / vold services and has **NOT** been runtime-tested.
