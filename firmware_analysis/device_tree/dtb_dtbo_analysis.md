# Boot Image, Kernel, DTB, and DTBO Analysis

- **Device:** TECNO POVA 6 Pro 5G (LI9)
- **Firmware Base:** HiOS 15.1.2.170SP05
- **Firmware Build:** OP001PF001AZ

Decompiled device tree sources generated directly from the stock binaries are stored alongside this report:
- Base SoC DTB: [mt6833_base.dts](mt6833_base.dts) (`193,651` B FDT v17 extracted from `vendor_boot.img`)
- Board Overlay DTBO: [li9_dtbo_0.dts](li9_dtbo_0.dts) (`67,890` B FDT v17 extracted from `dtbo.img`)

---

## 1. Boot Image Architecture (`boot.img`, `vendor_boot.img`, `init_boot`)

| Parameter | `boot.img` | `vendor_boot.img` | `vendor_boot-debug.img` |
|---|---|---|---|
| Magic / Header Version | `ANDROID!` / v4 | `VNDRBOOT` / v4 | `VNDRBOOT` / v4 |
| Partition Size (Scatter) | `41,943,040` B (40 MiB) | `67,108,864` B (64 MiB) | `67,108,864` B (64 MiB) |
| Header Size | `1,584` B | `2,128` B | `2,128` B |
| Page Size | `4096` B (inherited from `vendor_boot`) | `4096` B | `4096` B |
| Kernel Payload | `14,627,179` B (`Image.gz`, gzip -> `36,665,856` B ARM64 `Image`) | N/A | N/A |
| Kernel / Ramdisk / Tags / DTB Load Addrs | Provided by `vendor_boot` | `0x40080000` / `0x51100000` / `0x47c80000` / `0x47c80000` | Identical |
| Base + Offsets (`BoardConfig.mk`) | Base `0x40000000` | Kernel `0x00080000`, Ramdisk `0x11100000`, Tags `0x07c80000`, DTB `0x07c80000` | Identical |
| Ramdisk Payload | **`0` B** (no ramdisk in `boot.img`) | `29,974,101` B (2 LZ4-legacy entries) | `30,224,035` B (2 LZ4-legacy entries, adds debug/adb configs) |
| Bootconfig | `0` B | `0` B | `0` B |
| Command Line | `""` (empty) | `bootopt=64S3,32N2,64N2` | `bootopt=64S3,32N2,64N2` |
| DTB Payload | None | `193,715` B (1 FDT blob at offset 64, size `193,651` B) | Identical |

### Observations & Important Boot Notes
1. **`init_boot` Partition Status:** `MT6833_Android_scatter.txt` allocates `init_boot_a` / `init_boot_b` (`8,388,608` B each), marked `file_name: NONE` (`is_download: false`). No `init_boot.img` is shipped in the firmware package.
2. **`boot.img` Zero-Length Ramdisk & Recovery Split:** `boot.img` ships strictly the GKI 6.6.102 kernel (`ramdisk_size = 0`). `vendor_boot.img` carries two LZ4-legacy vendor ramdisks in its v4 table (`2 × 108 B` entries):
   - Entry #0 (`VENDOR_RAMDISK_TYPE_PLATFORM`, 203 files): `first_stage_ramdisk/fstab.mt6833`, `lib/modules/` (178 `.ko` modules, `modules.load`, `modules.load.recovery` [191 entries], `modules.dep`, `modules.alias`, `modules.softdep`).
   - Entry #1 (`VENDOR_RAMDISK_TYPE_RECOVERY`, name `recovery`, 515 files): full recovery userspace (`init`, `system/bin/recovery`, `fastbootd`, `mtk_plpath_utils`, `prop.default`, `init.recovery.mt6833.rc`, `system/etc/recovery.fstab`, SELinux policy/contexts).
   - **Verification Note:** Because `boot.img` has `ramdisk_size = 0` and no `init_boot.img` is shipped, LK loads the `vendor_boot` ramdisks and binds first-stage `init` from the combined ramdisk / `system` root (`root=/dev/ram` in DTB `/chosen`). When building custom `boot.img` / `vendor_boot.img`, verify boot behavior against stock LK on live hardware (`UNKNOWN — NEEDS VERIFICATION` until tested on device).
3. **Kernel Command Line Composition:** Final kernel arguments combine `vendor_boot` cmdline (`bootopt=64S3,32N2,64N2`), DTB `/chosen/bootargs`:
   ```text
   console=tty0 root=/dev/ram 8250.nr_uarts=4 rcupdate.rcu_expedited=1 vmalloc=400M swiotlb=noforce firmware_class.path=/vendor/firmware androidboot.hardware=mt6833 transparent_hugepage=never initcall_debug=1
   ```
   plus runtime parameters injected by LK (`androidboot.slot_suffix`, `androidboot.verifiedbootstate`, `androidboot.serialno`, etc.).

---

## 2. Base DTB Subsystem Analysis (`mt6833_base.dts`)

- **Source:** `vendor_boot.img` DTB section (offset 64 within DTB blob, FDT v17, `193,651` B, 475 nodes with `compatible`).
- **Root Node:** `model = "MT6833"`, `compatible = "mediatek,MT6833"`, `#address-cells = <2>`, `#size-cells = <2>`.

| Subsystem | Key Nodes & Verified Compatible Strings | Hardware Role / Notes |
|---|---|---|
| **CPUs** | `/cpus/cpu@000..005` (`arm,cortex-a55`, capacity `0x195`), `/cpus/cpu@100..101` (`arm,cortex-a76`, capacity `0x400`) | 6+2 big.LITTLE Dimensity 6080 topology (500–2000 MHz / 725–2400 MHz) |
| **Memory & Reserved Memory** | `/memory` (`0x40000000`, placeholder `0x3e605000`); 8 `/reserved-memory` regions: `ssmr-reserved-cma_memory` (256 MiB), `wifi-reserve-memory` (6 MiB), `consys-reserve-memory` (5 MiB), `scp_share` (4.125 MiB), `sspm_share` (5.06 MiB), `mcupm_share` (6.06 MiB), `ccci-dpmaif-cache` (1.56 MiB), `ccci-dpmaif-nocache` (320 KiB) | Runtime RAM size populated by LK; shared DMA pools for TEE/SSMR, Connsys, SCP, SSPM, MCUPM, and 5G modem DPMAIF |
| **Interrupt Controller & GPIO** | ARM GICv3 (`arm,gic-v3`), `/apirq@1000b000` (`mediatek,mtk-eint`), `/pinctrl` (`mediatek,mt6833-pinctrl`), `/scp_gpio@10005000` | SoC IRQ routing, EINT external interrupts, GPIO pinmux |
| **Buses (I2C / SPI / UART)** | 10 I2C buses (`mediatek,mt6873-i2c` at `0x11cb0000`, `0x11d00000`, `0x11d01000`, `0x11d20000..22000`, `0x11e00000..e02000`, `0x11f00000`), SPI controllers, 2 UARTs (`serial@11002000/3000`, `mediatek,mt6577-uart` + `mediatek,mt6779-uart-dma`) | Board peripherals attached via DTBO overlays |
| **Clocks, Power Domains & Regulators** | `/power-controller@10006000` (`mediatek,mt6833-scpsys`), `mt6833` topckgen/infracfg/pericfg/mmsys/camsys/vdec/venc clock controllers; PMIC `pwrap@10026000/mt6359p` (`mediatek,mt6359p-regulator`) + `mt6360@34/regulator` | Hardware power domains, DVFSRC (`mtk-dvfsrc-devfreq`), voltage rails |
| **Storage** | `/ufshci@11270000` (`mediatek,mt8183-ufshci`, inline crypto boost, `ufs-qos`), `/mmc@11230000` (`status="disabled"`), `/mmc@11240000` (`status="okay"`, 4-bit SD UHS-I SDR104) | UFS internal flash + removable microSD slot |
| **Display Pipeline** | `/dispsys_config@14000000` (`mediatek,mt6833-disp`), `disp_ovl0`, `disp_ovl0_2l`, `disp_rdma0`, `disp_rsz0`, `disp_color0`, `disp_ccorr0`, `disp_aal0`, `disp_gamma0`, `disp_postmask0`, `disp_dither0`, `disp_wdma0`, `/dsi@14013000` (`mediatek,mt6833-dsi`), `/disp_pwm0@1100e000`, `/drm_wv` | MTK DRM display subsystem driving DSI0 panel (attached in DTBO) |
| **GPU** | `/mali@13000000` (`mediatek,mali`, `arm,mali-valhall`), `/gpufreq`, `/ged` | ARM Mali-G57 Valhall GPU with MTK GED / GPUFreq DVFS |
| **Audio** | `/mt6833-afe-pcm@11210000` (`mediatek,mt6833-sound`), `/audio_sram@11212000`, `mt6359codec` (`mediatek,mt6359p-sound`), `mt6359p-accdet`, `/snd-scp-ultra`, `/mtk-btcvsd-snd@18050000`, `/sound` (`mediatek,mt6833-mt6359p-sound`) | AFE PCM + MT6359P codec + SCP ultrasound + BT CVSD (SmartPAs added in DTBO) |
| **Camera ISP & Video Codecs** | `/seninf_top@1a004000` (`seninf1..6`), `/kd_camera_hw1@1a004000` (`mediatek,imgsensor`), `camsys_rawa/b/c`, `/camera_af_hw_node`, `/soc/vdec@16000000` (`mt6833-vcodec-dec`), `/soc/venc@17000000` (`mt6833-vcodec-enc`) | Camera ISP pipeline and hardware V4L2 video decode/encode |
| **Thermal** | `/lvts@1100b000` (`mediatek,mt6833-lvts`), `thermal-sensor1..3` (`mtboard-thermistor1..3`), `mtk-ts-pmic`, `thermal_ipi_legacy` | On-die LVTS sensors + board NTC thermistors + PMIC temperature |
| **Battery & Charging** | `mt6359p/mtk-gauge`, `mt6360@34` (`mt6360-chg`, `mt6360-adc`, `mt6360-led`), `tcpc@4e` (`mt6360_typec`), `rt-pd-manager`, `pe`, `pe2`, `pdc`, `pe4`, `battery-manager`, `charger` | Base MTK PMIC/TCPC charging stack (dual HL7139 70W charge pumps added in DTBO) |
| **USB** | `/usb0@0x11200000` (`mediatek,mt6833-usb20`), `/usb-phy@11e40000` (`mediatek,generic-tphy-v2`), `/extcon_usb`, `/usb-boost-manager` | USB 2.0 OTG (`musb-hdrc`) with MT6360 Type-C PD controller |
| **Wi-Fi / BT / GNSS / Connsys** | `/consys@18002000` (`mediatek,mt6833-consys`), `/wifi@18000000` (`mediatek,wifi`), `/btif@1100c000` (`mediatek,btif`) | Integrated MT6833 Connsys (Gen4m Wi-Fi, Connac1x BT, STP GNSS) |
| **Modem** | `/dpmaif@10014000` (`mediatek,dpmaif`), `/ccifdriver@10209000` (`mediatek,ccci_ccif`), `md-auxadc`, `md_ccci_rtc`, `ccci-scp`, `md_power_throttling` | 5G NR/LTE CCCI/DPMAIF modem interface (`md1img.img`) |
| **Sensors / SCP / IR / TEE** | `/scp@10500000` (`mediatek,scp`), `/irtx_pwm` (`mediatek,irtx-pwm`), `/fingerprint` (`mediatek,goodix-fp`), `/trusty` / `/nebula` | Sensor hub on SCP, PWM IR transmitter, Goodix FP base node |
| **NPU / APU** | Only `/disable_unused/disable-unused-pd-apu` present in base DTB; dedicated APU compute node absent | Consistent with Dimensity 6080 (MT6833) SKU positioning; NNAPI shim present in vendor |

---

## 3. DTBO Overlay Analysis (`dtbo.img` -> `li9_dtbo_0.dts`)

- **Container Format:** Android DTBO Table v0 (`magic = 0xD7B7AB1E`), partition size `8,388,608` B (8 MiB), `dt_entry_count = 1`, `page_size = 2048`.
- **Entry #0 Metadata:** `dt_size = 67,890` B, `dt_offset = 64`, `id = 0`, `rev = 0`, `custom = [0, 0, 0, 0]`.
- **Overlay Structure:** 73 top-level `/fragment@0`..`/fragment@72` overlay blocks (333 total subnodes, 77 compatible nodes) applied by LK over `mt6833_base.dtb` using `__fixups__` / `__local_fixups__` symbols.

### Board-Specific Hardware Added by `li9_dtbo_0.dts`

| Fragment(s) | Node & Compatible String | Board-Specific Function on LI9 |
|---|---|---|
| `fragment@4`, `fragment@5` | `aw87xxx_pa@58`, `aw87xxx_pa@59` (`awinic,aw87xxx_pa`), `tran_audio_controller` | Dual stereo Awinic SmartPA amplifiers + Transsion audio routing |
| `fragment@6`, `fragment@9`, `fragment@11` | `panel1@0` (`nt37703a,fhdp,dsi,vdo,tm,tm,li9`), `lcm_rst_out*`, `lcm_dsi_te`, `backlight` | Tianma Novatek NT37703A 1080×2436 120 Hz AMOLED panel (DVDD/VCI/RST GPIOs, doze backlight levels `<3 5 7 31>`) |
| `fragment@13`, `fragment@58` | `nfc_nxp@28` / `nfc@28` (`nxp,pn544`), `irq_nfc` | NXP PN560 NFC controller on I2C addr `0x28` |
| `fragment@19`, `fragment@20`, `fragment@21` | `fingerprint@0`, `gpio9_eint`, `rst_out_*`, `spimode_default` | Goodix optical under-display fingerprint SPI & GPIO pinmux |
| `fragment@22` | `gps_l1_lna@0..2`, `gps_l5_lna@0..2` | External dual-band GPS L1/L5 LNA GPIO controls |
| `fragment@24`–`fragment@37` | `hl7138_master@55`, `hl7138_slave@55` (`tc,hl7139`), `tfcp_ta@1b`, `pe5`, `tc_pd_adapter`, `water_detect`, `pid_chg` | Dual Halo Micro HL7138/HL7139 master/slave charge pumps (`vbatovp=4.55V`, `vbusovp=11V`) implementing 70W TFCP/PD/PE5 fast charging & USB water detection |
| `fragment@38`, `fragment@39` | `aw20216_led@20` (`awinic,aw20216_led`), `tc_led` | Rear Dynamic-Eye / Mecha RGB LED matrix controller on I2C `0x20` |
| `fragment@41` | `fshaptic@34` (`foursemi,fshaptic`) | FourSemi FS3001 LRA haptic driver on I2C `0x34` (`f0_ref=0x92e` = 235.0 Hz) |
| `fragment@42`–`fragment@44` | `focaltech@0` (`focaltech,fts`, SPI 8 MHz, coords `0x437f × 0x983f` = `1080×2436 × 16`, 10-point touch, `fod-function-support`, `pocket-function-support`) | FocalTech FT3683G touchscreen controller with UDFPS FOD & pocket mode |
| `fragment@45`–`fragment@64` | `camera_main@1a`, `camera_main_af@72`, `camera_main_two@10`, `camera_sub@1a`, `camera-eeprom0@50`, `camera-eeprom1@51`, `et5904@28` (`tran,et5904` 4-LDO camera PMIC), `flashlights_ocp81375`, `flashlights_aw36515`, `strobe_main@63` | 108MP rear + aux + 32MP front camera sensors, VCM autofocus, calibration EEPROMs, dedicated camera LDO PMIC, and LED flash drivers |

### Relationship Between Base DTB and DTBO
- `vendor_boot.img` supplies the generic `mt6833` SoC base tree (`mt6833_base.dtb`).
- `dtbo.img` supplies the single LI9 board overlay (`li9_dtbo_0.dtb`, `id=0`, `rev=0`).
- At boot, LK applies `li9_dtbo_0.dtb` onto `mt6833_base.dtb` before jumping to the GKI `6.6.102` kernel. Any custom kernel or DTBO rebuild **must** preserve all 73 overlay fragments (especially panel `nt37703a`, touch `focaltech@0`, dual `hl7138` charge pumps, `aw87xxx` SmartPAs, `et5904` camera PMIC, `fshaptic@34`, and `nfc@28`) to prevent display/touch/charging/audio bringup failures.
