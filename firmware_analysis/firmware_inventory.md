# Firmware Inventory — TECNO POVA 6 Pro 5G (LI9)

- **Firmware Base:** `HiOS 15.1.2.170SP05`
- **Firmware Build:** `OP001PF001AZ`
- **Device:** `TECNO POVA 6 Pro 5G (LI9)`
- **Source Directory (local):** `E:\Tecno-POVA-6-Pro-LI9-15-02` (original firmware left completely unmodified)
- **Archive Observed Nearby:** `E:\Tecno-POVA-6-Pro-LI9-15-02.zip` (9,950,403,966 bytes; source archive of the same build)

## Package Structure & Base vs Open Verification

This MediaTek SP Flash Tool package ships two variant definitions listed in `version.csv`:

| Variant ID | Name | Display ID Verified | Scatter File | Key Overridden Images |
| :--- | :--- | :--- | :--- | :--- |
| `0` | Base | `LI9-15.1.2.170SP05(BASE001PF001AZ)` (`tkv.img`, `product/etc/build.prop`) | `MT6833_Android_scatter.txt` | Root images (`super.img`, `vbmeta.img`, `tkv.img`) |
| `10` | **Open (Target)** | **`LI9-15.1.2.170SP05(OP001PF001AZ)`** (`Open/tkv.img`, `Open/super.img:tr_product_a/etc/build.prop`) | `Open/Open_scatter.txt` | `Open/super.img` (delta sparse updating `tr_product_a`, `tr_preload_a`, `tr_region_a`), `Open/vbmeta.img`, `Open/tkv.img` |

> **Important Observation:** `Open/logo.bin` and `Open/md1img.img` are byte-for-byte identical (SHA-256 verified) to root `logo.bin` and `md1img.img`. `Open/super.img` is an Android sparse delta image whose `system_a`, `system_ext_a`, `product_a`, `vendor_a`, `vendor_dlkm_a`, `system_dlkm_a`, and `odm_dlkm_a` extents are `DONT_CARE` chunks, preserving the Base `super.img` OS/vendor partitions while updating the Transsion customization partitions (`tr_product_a`, `tr_preload_a`, `tr_region_a`) and LP metadata for `OP001PF001AZ`. No mixed/unrelated firmware versions were found in the package.

## Complete File Inventory (75 files)

| File | Size | Format | Partition | Function | Extractable | DT Relevant | Digest (`sha256` prefix) | Status |
| :--- | ---: | :--- | :--- | :--- | :---: | :---: | :--- | :--- |
| `APDB_MT6853_S01__W2518` | 250.62 KiB (256,637 B) | APDB (MTK) | N/A (META tool DB) | MediaTek AP database for META/calibration tools | No | No | `2cef9c62c6062411` | Analyzed (header) |
| `APDB_MT6853_S01__W2518_ENUM` | 21.88 KiB (22,404 B) | APDB ENUM | N/A (META tool DB) | MediaTek APDB enum definitions | No | No | `605e7b645faa2756` | Analyzed (header) |
| `boot.img` | 40.00 MiB (41,943,040 B) | Android Boot v4 (GKI) | boot_a / boot_b (40 MiB) | GKI Linux 6.6.102 ARM64 Image.gz kernel + AVB v2 footer (ramdisk_size=0) | Yes | Yes | `1545d7f81d6d2c74` | Extracted & Analyzed |
| `Checksum.ini` | 501 B (501 B) | INI text | N/A (SP Flash Tool) | Base package download checksums | No | No | `2ba1d56fc20433cd` | Analyzed |
| `dpm.img` | 144.50 KiB (147,968 B) | MTK Header (dpmpm) | dpm_a / dpm_b (4 MiB) | DRAM Power Management firmware | No | No | `a24f12c2bcc5b755` | Analyzed (header) |
| `dtbo.img` | 8.00 MiB (8,388,608 B) | Android DTBO v0 | dtbo_a / dtbo_b (8 MiB) | Device Tree Blob Overlay (1 LI9 board overlay) + AVB footer | Yes | Yes | `427acb8cd5b7d95c` | Extracted, Decompiled & Analyzed |
| `efuse_MT6833.xml` | 2.40 KiB (2,456 B) | XML text | N/A (Factory eFuse) | MT6833 SP Flash Tool eFuse/SBC public key configuration | No | No | `be78ca112c0c4a10` | Analyzed |
| `gz.img` | 2.49 MiB (2,608,496 B) | MTK Header (gz) | gz_a / gz_b (32 MiB) | GenieZone hypervisor / MTEE firmware | No | No | `4aab126f8e3db964` | Analyzed (header) |
| `installed-files-ramdisk.txt` | 229 B (229 B) | TXT text | N/A (Build manifest) | Generic ramdisk file list artifact from build | No | Yes | `44a6e2061dd1390d` | Analyzed |
| `installed-files-vendor.txt` | 266.50 KiB (272,897 B) | TXT text | N/A (Build manifest) | Vendor partition installed file sizes manifest | No | Yes | `cd16f7993f452758` | Analyzed |
| `lk.img` | 1.26 MiB (1,325,984 B) | MTK Header (lk) | lk_a / lk_b (2 MiB) | Little Kernel secondary bootloader (fastboot/AVB) | No | Yes | `17ddcedf2767b29e` | Analyzed (header) |
| `Log/ADPT_20260421-222151_0.log` | 190 B (190 B) | Log TXT | N/A | ADPT checksum generation log | No | No | `1e1201a113ceb4c3` | Analyzed |
| `logo.bin` | 2.46 MiB (2,582,064 B) | MTK Header (logo) | logo_a / logo_b (8 MiB) | Boot splash and charging logo assets (identical in Base & Open) | No | No | `29a71581f9f523ea` | Analyzed (header & hash) |
| `mcupm.img` | 400.67 KiB (410,288 B) | MTK Header (mcupm) | mcupm_a / mcupm_b (1 MiB) | MCU Power Management RISC-V firmware | No | No | `8b9d64a036b59f0a` | Analyzed (header) |
| `md1img.img` | 60.52 MiB (63,455,024 B) | MTK Header (md1rom) | md1img_a / md1img_b (200 MiB) | MediaTek 5G NR/LTE/WCDMA/GSM baseband modem firmware (identical in Base & Open) | No | Yes | `603766096bb2b67c` | Analyzed (header & hash) |
| `MDDB_InfoCustomAppSrcP_MT6833_S00_MOLY_NR15_R3_MP_V228_4_P2_1_unlwctg_n.EDB` | 10.82 MiB (11,348,562 B) | MTK MDDB | N/A (Modem DB) | Modem MOLY NR15 R3 database for engineering tools | No | No | `26154e5fbe2c3d11` | Analyzed (header) |
| `MT6833_Android_scatter.txt` | 54.70 KiB (56,013 B) | YAML-like TXT | N/A (Partition table) | MT6833 Base scatter table (61 EMMC + 61 UFS partitions) | No | Yes | `470f221efccd61bc` | Parsed & Verified |
| `MT6833_Android_scatter.xml` | 90.82 KiB (92,997 B) | XML text | N/A (Partition table) | MT6833 XML scatter table | No | Yes | `d2a4d5d58c637cb7` | Verified |
| `odm_dlkm.img` | 340.00 KiB (348,160 B) | EROFS + AVB | odm_dlkm_a (logical) | ODM dynamic loadable kernel module partition (metadata only, 0 .ko) | Yes | Yes | `35c532a145c7434d` | Extracted & Analyzed |
| `odm_dlkm.map` | 32 B (32 B) | Block map TXT | N/A | Block map for odm_dlkm | No | No | `a86b28850c91b069` | Analyzed |
| `Open/Checksum.ini` | 501 B (501 B) | INI text | N/A (SP Flash Tool) | Open (OP001PF001AZ) package checksums | No | Yes | `9a1a3d600a9ddea7` | Analyzed |
| `Open/Log/ADPT_20260421-222151_0.log` | 190 B (190 B) | Log TXT | N/A | ADPT checksum generation log | No | No | `2c69b6f7ff845529` | Analyzed |
| `Open/logo.bin` | 2.46 MiB (2,582,064 B) | MTK Header (logo) | logo_a / logo_b (8 MiB) | Open variant boot logo (SHA-256 identical to Base logo.bin) | No | No | `29a71581f9f523ea` | Verified Identical |
| `Open/md1img.img` | 60.52 MiB (63,455,024 B) | MTK Header (md1rom) | md1img_a (200 MiB) | Open variant modem image (SHA-256 identical to Base md1img.img) | No | Yes | `603766096bb2b67c` | Verified Identical |
| `Open/Open_scatter.txt` | 55.13 KiB (56,449 B) | YAML-like TXT | N/A (Partition table) | Open (OP001PF001AZ) scatter file referencing Open/* overrides | No | Yes | `70ea768749aa0bda` | Parsed & Diffed |
| `Open/super.img` | 1506.10 MiB (1,579,258,604 B) | Android Sparse Delta + LP v10.2 + EROFS | super (9800 MiB) | Open variant sparse delta overriding tr_product_a (OP001PF001AZ), tr_preload_a, tr_region_a | Yes | Yes | `partial:d0eee753e1c1` | Parsed LP & Extracted All Configs |
| `Open/tkv.img` | 516.19 KiB (528,576 B) | MTK Header (tkv) | tkv_a / tkv_b (1 MiB) | Open variant TKV metadata confirming LI9-15.1.2.170SP05(OP001PF001AZ) | No | Yes | `dca287ccdca06557` | Analyzed (strings & hash) |
| `Open/tool_custom.ini` | 71 B (71 B) | INI text | N/A (Aftersales) | Open variant build prefix: TECNO/LI9-OP/TECNO-LI9:15 | No | Yes | `f6941c611d81915a` | Analyzed |
| `Open/vbmeta.img` | 12.00 KiB (12,288 B) | AVB0 v1.0 | vbmeta_a (8 MiB) | Open variant top-level AVB vbmeta matching Open tr_product/tr_preload/tr_region | Yes | Yes | `24ac19c59dba20d7` | Parsed & Verified |
| `pi_img.img` | 5.72 KiB (5,856 B) | MTK Header (pi_img) | pi_img_a / pi_img_b (1 MiB) | Platform Info firmware image | No | No | `10b5f5bdb0a4b260` | Analyzed (header) |
| `preloader.img` | 439.39 KiB (449,940 B) | MTK COMBO_BOOT | preloader (1 MiB) | Combo EMMC/UFS preloader with COMBO_BOOT header | No | No | `d1ae8aae1d27dba0` | Analyzed (header) |
| `preloader_emmc.img` | 439.39 KiB (449,940 B) | MTK COMBO_BOOT | preloader (1 MiB) | eMMC preloader image | No | No | `d1ae8aae1d27dba0` | Analyzed (header) |
| `preloader_li9_h335.bin` | 435.39 KiB (445,844 B) | MTK Signed Preloader | preloader (BOOT1/LU0) | Primary LI9_H335 signed preloader (referenced by scatter) | No | Yes | `fd668d70e43e9325` | Analyzed (header) |
| `preloader_raw.img` | 435.39 KiB (445,844 B) | MTK Signed Preloader | preloader_raw_a/b | Raw preloader image for A/B OTA | No | No | `fd668d70e43e9325` | Analyzed (header) |
| `preloader_ufs.img` | 439.39 KiB (449,940 B) | MTK COMBO_BOOT | preloader (UFS LU0/1) | UFS preloader image | No | No | `d1ae8aae1d27dba0` | Analyzed (header) |
| `product.map` | 41.66 KiB (42,659 B) | Block map TXT | N/A | Block map for product | No | No | `22b1cfd41b015718` | Analyzed |
| `scp.img` | 521.69 KiB (534,208 B) | MTK Header (scp) | scp_a / scp_b (6 MiB) | System Companion Processor (sensor hub / audio) RISC-V firmware | No | Yes | `5c2e9bbbed1cc90d` | Analyzed (header) |
| `spmfw.img` | 14.52 KiB (14,864 B) | MTK Header (spmfw) | spmfw_a / spmfw_b (1 MiB) | System Power Manager firmware | No | No | `9c502df5667ff35f` | Analyzed (header) |
| `sspm.img` | 540.67 KiB (553,648 B) | MTK Header (sspm) | sspm_a / sspm_b (1 MiB) | Secure System Power Manager firmware | No | No | `94fd5e291358942c` | Analyzed (header) |
| `super.img` | 7670.95 MiB (8,043,576,480 B) | Android Sparse + LP v10.2 + EROFS | super (9800 MiB) | Base dynamic partitions container (system, system_ext, product, vendor, *_dlkm, tr_*) | Yes | Yes | `partial:27ea434ab623` | Parsed LP & Extracted All Configs |
| `super_empty.img` | 5.98 KiB (6,120 B) | Android LP v10.2 Metadata | super (metadata template) | Empty dynamic partition metadata template (main_a / main_b) | Yes | Yes | `bd393d728401c218` | Parsed & Verified |
| `system.map` | 165.07 KiB (169,035 B) | Block map TXT | N/A | Block map for system | No | No | `03fba9f97217ce43` | Analyzed |
| `system_dlkm.img` | 6.96 MiB (7,294,976 B) | EROFS + AVB | system_dlkm_a (logical) | GKI 6.6.102 system kernel modules (78 .ko modules) | Yes | Yes | `1fda77e1dc938840` | Extracted & Analyzed |
| `system_dlkm.map` | 3.56 KiB (3,641 B) | Block map TXT | N/A | Block map for system_dlkm | No | No | `e289de73a971fcb5` | Analyzed |
| `system_ext.map` | 57.15 KiB (58,520 B) | Block map TXT | N/A | Block map for system_ext | No | No | `222f68aa01af1a99` | Analyzed |
| `tee.img` | 835.88 KiB (855,936 B) | MTK Header (atf) | tee_a / tee_b (5/8 MiB) | ARM Trusted Firmware + Trustonic TEE image | No | Yes | `405330ec6d2de456` | Analyzed (header) |
| `tkv.img` | 516.19 KiB (528,576 B) | MTK Header (tkv) | tkv_a / tkv_b (1 MiB) | Transsion Base key-value metadata (BASE001PF001AZ) | No | Yes | `7a156fa172c6c213` | Analyzed (strings & hash) |
| `tool_custom.ini` | 71 B (71 B) | INI text | N/A (Aftersales) | Build prefix metadata: TECNO/LI9-OP/TECNO-LI9:15 | No | Yes | `f6941c611d81915a` | Analyzed |
| `tr_carrier.img` | 20.09 KiB (20,568 B) | Android Sparse (EROFS + AVB) | tr_carrier_a (logical) | Transsion Base stub partition (tr_carrier) | Yes | No | `85af493986703f08` | Analyzed (header) |
| `tr_carrier.map` | 0 B (0 B) | Block map TXT | N/A | Block map for tr_carrier | No | No | `e3b0c44298fc1c14` | Analyzed |
| `tr_company.img` | 20.09 KiB (20,568 B) | Android Sparse (EROFS + AVB) | tr_company_a (logical) | Transsion Base stub partition (tr_company) | Yes | No | `95a293af973925c6` | Analyzed (header) |
| `tr_company.map` | 0 B (0 B) | Block map TXT | N/A | Block map for tr_company | No | No | `e3b0c44298fc1c14` | Analyzed |
| `tr_mi.img` | 976.10 KiB (999,524 B) | Android Sparse (EROFS + AVB) | tr_mi_a (logical) | Transsion Base stub partition (tr_mi) | Yes | No | `4c6f6d9a8091009e` | Analyzed (header) |
| `tr_mi.map` | 346 B (346 B) | Block map TXT | N/A | Block map for tr_mi | No | No | `952184066b5d31b0` | Analyzed |
| `tr_overlayfs.img` | 20.09 KiB (20,568 B) | Android Sparse (EROFS + AVB) | tr_overlayfs_a (logical) | Transsion Base stub partition (tr_overlayfs) | Yes | No | `5618432545d39286` | Analyzed (header) |
| `tr_overlayfs.map` | 0 B (0 B) | Block map TXT | N/A | Block map for tr_overlayfs | No | No | `e3b0c44298fc1c14` | Analyzed |
| `tr_preload.img` | 20.09 KiB (20,568 B) | Android Sparse (EROFS + AVB) | tr_preload_a (logical) | Transsion Base stub partition (tr_preload) | Yes | No | `d8f1cad68b5d2f46` | Analyzed (header) |
| `tr_preload.map` | 0 B (0 B) | Block map TXT | N/A | Block map for tr_preload | No | No | `e3b0c44298fc1c14` | Analyzed |
| `tr_product.img` | 20.09 KiB (20,568 B) | Android Sparse (EROFS + AVB) | tr_product_a (logical) | Transsion Base stub partition (tr_product) | Yes | No | `076d04e80dd05994` | Analyzed (header) |
| `tr_product.map` | 0 B (0 B) | Block map TXT | N/A | Block map for tr_product | No | No | `e3b0c44298fc1c14` | Analyzed |
| `tr_region.img` | 20.09 KiB (20,568 B) | Android Sparse (EROFS + AVB) | tr_region_a (logical) | Transsion Base stub partition (tr_region) | Yes | No | `2df215bf44199c2e` | Analyzed (header) |
| `tr_region.map` | 0 B (0 B) | Block map TXT | N/A | Block map for tr_region | No | No | `e3b0c44298fc1c14` | Analyzed |
| `tr_theme.img` | 20.09 KiB (20,568 B) | Android Sparse (EROFS + AVB) | tr_theme_a (logical) | Transsion Base stub partition (tr_theme) | Yes | No | `100aa875542c79a9` | Analyzed (header) |
| `tr_theme.map` | 0 B (0 B) | Block map TXT | N/A | Block map for tr_theme | No | No | `e3b0c44298fc1c14` | Analyzed |
| `tranfs.img` | 92.14 KiB (94,356 B) | Android Sparse (ext4) | tranfs (302 MiB) | Transsion auxiliary partition | No | No | `540816607ce99a6c` | Analyzed (header) |
| `userdata.img` | 2.27 MiB (2,380,076 B) | Android Sparse (f2fs) | userdata (3072 MiB initial) | Initial empty F2FS userdata filesystem image | No | Yes | `7b640c2100810c50` | Analyzed (header) |
| `vbmeta.img` | 12.00 KiB (12,288 B) | AVB0 v1.0 | vbmeta_a / vbmeta_b (8 MiB) | Base top-level AVB vbmeta (SHA256_RSA2048, chains boot/vbmeta_system/vbmeta_vendor) | Yes | Yes | `861dbd75647ec300` | Parsed & Verified |
| `vbmeta_system.img` | 4.00 KiB (4,096 B) | AVB0 v1.0 | vbmeta_system_a/b (8 MiB) | AVB vbmeta for system (TSSI Android 15, hashtree sha256 FEC=2) | Yes | Yes | `d0e30642304949ef` | Parsed & Verified |
| `vbmeta_vendor.img` | 4.00 KiB (4,096 B) | AVB0 v1.0 | vbmeta_vendor_a/b (8 MiB) | AVB vbmeta for vendor (LI9-OP 260421V1373, hashtree sha256 FEC=2) | Yes | Yes | `91f62415e017da48` | Parsed & Verified |
| `vendor.map` | 151.75 KiB (155,389 B) | Block map TXT | N/A | Block map for vendor | No | No | `c865ef2b63d02741` | Analyzed |
| `vendor_boot-debug.img` | 29.02 MiB (30,429,184 B) | Android Vendor Boot v4 (debug) | N/A (Debug artifact) | Debug variant of vendor_boot (206 platform files, same DTB & recovery) | Yes | No | `0a30166140e522f7` | Unpacked & Compared |
| `vendor_boot.img` | 64.00 MiB (67,108,864 B) | Android Vendor Boot v4 | vendor_boot_a/b (64 MiB) | MT6833 DTB + PLATFORM ramdisk (178 .ko, fstab.mt6833) + RECOVERY ramdisk | Yes | Yes | `f6bd8647445c1759` | Extracted, Decompiled & Analyzed |
| `vendor_dlkm.img` | 13.36 MiB (14,008,320 B) | EROFS + AVB | vendor_dlkm_a (logical) | Vendor dynamic loadable kernel modules (158 .ko modules) | Yes | Yes | `2a0f611d5395c474` | Extracted & Analyzed |
| `vendor_dlkm.map` | 8.88 KiB (9,092 B) | Block map TXT | N/A | Block map for vendor_dlkm | No | No | `e8092cfaeb4f93e8` | Analyzed |
| `version.csv` | 336 B (336 B) | CSV text | N/A (Package index) | Transsion Base (0) vs Open (10) variant mapping | No | Yes | `ceb1f7a5c25a1ee2` | Analyzed |

## Logical Partitions Inside `super.img` + `Open/super.img`

LP Metadata version: `10.2` (`metadata_max_size=65536`, `metadata_slot_count=3`, `logical_block_size=4096`, `super` block device size = `10,276,044,800` bytes / `9800 MiB`, group `main_a` / `main_b` max size = `10,273,947,648` bytes).

| Logical Partition (`_a`) | Filesystem | EROFS `feature_incompat` | Base `super.img` Size | `Open/super.img` Effective Size | Notes |
| :--- | :--- | :--- | ---: | ---: | :--- |
| `system_a` | EROFS (LZ4) | `0x1` (`ZERO_PADDING`) | 921,378,816 B (878.70 MiB) | Inherited from Base | TSSI Android 15 (`AP3A.240905.015.A2`, `260421V1228`) |
| `system_ext_a` | EROFS (LZ4) | `0x1` (`ZERO_PADDING`) | 2,733,166,592 B (2606.55 MiB) | Inherited from Base | `LI9-OP` (`170005`) |
| `product_a` | EROFS (LZ4) | `0x1` (`ZERO_PADDING`) | 3,220,037,632 B (3070.87 MiB) | Inherited from Base | `LI9-OP` (`170005`), HiOS 15.1.2, overlays & `power_profile.xml` |
| `vendor_a` | EROFS (LZ4) | `0x1` (`ZERO_PADDING`) | 1,173,725,184 B (1119.35 MiB) | Inherited from Base | `LI9-OP` (`260421V1373`), MT6833 AIDL HALs, firmware, configs |
| `vendor_dlkm_a` | EROFS (LZ4) | `0x1` (`ZERO_PADDING`) | 14,008,320 B (13.36 MiB) | Inherited from Base | 158 vendor `.ko` modules (6.6.102-android15-8) |
| `system_dlkm_a` | EROFS (LZ4) | `0x1` (`ZERO_PADDING`) | 7,294,976 B (6.96 MiB) | Inherited from Base | 78 GKI `.ko` modules (6.6.102-android15-8) |
| `odm_dlkm_a` | EROFS (LZ4) | `0x1` (`ZERO_PADDING`) | 348,160 B (0.33 MiB) | Inherited from Base | Metadata only (no `.ko` modules) |
| `tr_product_a` | EROFS (LZ4) | `0x1` (`ZERO_PADDING`) | 348,160 B (0.33 MiB) | **50,081,792 B (47.76 MiB)** | Overridden by Open (`ro.build.display.id=LI9-15.1.2.170SP05(OP001PF001AZ)`) |
| `tr_preload_a` | EROFS (LZ4) | `0x1` (`ZERO_PADDING`) | 348,160 B (0.33 MiB) | **1,533,820,928 B (1462.77 MiB)** | Overridden by Open (preloaded partner APKs; excluded from DT) |
| `tr_mi_a` | EROFS (LZ4) | `0x1` (`ZERO_PADDING`) | 1,081,344 B (1.03 MiB) | 348,160 B (0.33 MiB) | Overridden by Open stub |
| `tr_region_a` | EROFS (LZ4) | `0x1` (`ZERO_PADDING`) | 348,160 B (0.33 MiB) | 348,160 B (0.33 MiB) | Overridden by Open (`ro.tran.region.name=Open`, `ro.tran.sw.market=op`) |
| `tr_theme_a`, `tr_carrier_a`, `tr_company_a`, `tr_overlayfs_a` | EROFS (LZ4) | `0x1` (`ZERO_PADDING`) | 348,160 B each | 348,160 B each | Stub Transsion customization partitions |

> All `_b` logical partitions (`*_b`) in `main_b` are initialized to 0 bytes (Virtual A/B snapshot updates).
