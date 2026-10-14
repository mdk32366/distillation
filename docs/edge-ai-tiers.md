# Edge AI hardware tiers

Where can a model run? This page sorts hardware by **memory and power budget**. Use it to decide which tier a model has to fit into, and how much distillation, quantization and pruning it will take to move a capability down a tier.

> **Figures are approximate.** Tier-wide ranges are rules of thumb. Where a row cites a vendor page, the numbers for *that part* were checked against it (Oct 2026). Fixes to the first draft are marked **(corrected)**.

| Tier | Example hardware | Memory (approx.) | Power (approx.) | Typical model size | What it can do | Verified source |
|---|---|---|---|---|---|---|
| **1a. Tiny MCU** | Cortex-M0/M4, Nordic nRF52, Arduino Nano 33 BLE Sense (nRF52840) | ~24-512 KB RAM, up to ~1 MB flash. The nRF52840 has 256 KB RAM and 1 MB flash. | milliwatts | tens to hundreds of KB | One sensor pattern: wake word, gesture, vibration fault | [nRF52840](https://www.nordicsemi.com/Products/nRF52840), [Nano 33 BLE Sense](https://docs.arduino.cc/hardware/nano-33-ble-sense/) |
| **1b. High-end MCU** | ESP32-S3 + PSRAM, STM32H7, NXP i.MX RT | ~0.5-1.5 MB on-chip SRAM, plus ~8-16 MB of external PSRAM/flash. The ESP32-S3 has 512 KB SRAM and supports external octal PSRAM. | tens to hundreds of mW | up to a few MB | Person detection, dozens of keywords, sensor fusion | [ESP32-S3](https://www.espressif.com/en/products/socs/esp32-s3) |
| **1c. MCU + NPU** | Kendryte K210, ADI MAX78000, Cortex-M55 + Ethos-U55/U65 (e.g. Alif Ensemble), Sony Spresense | **~0.5-10 MB on chip (corrected from 8-64 MB).** K210: 8 MiB SRAM. MAX78000: 128 KB SRAM, 512 KB flash, 442 KB CNN weight memory (≈3.5M weights max). Alif E8: 9.75 MB SRAM. | sub-mW to ~1 W; MAX78000 inference costs microjoules | ~0.4-6 MB | Low-res real-time vision, small command sets | [K210 datasheet](https://github.com/kendryte/kendryte-doc-datasheet/blob/master/en/003.md), [MAX78000](https://www.maximintegrated.com/en/products/microcontrollers/MAX78000.html), [Ethos-U55 brief](https://armkeil.blob.core.windows.net/developer/Files/pdf/product-brief/arm-ethos-u55-product-brief.pdf), [Alif E8](https://alifsemi.com/ensemble-e8-series/), [Spresense](https://developer.sony.com/spresense/) |
| **1d. Crossover / small Linux SoC** | Rockchip RV1103/RV1106 (Luckfox Pico), SigmaStar, Ambarella, Allwinner V851 | 32-256 MB DRAM, often in-package. Luckfox: 64 MB (RV1103), 128 / 256 MB (RV1106G2/G3). NPU rated 0.5-1 TOPS int8. | ~0.5-2 W | 5-100 MB | Smart IP cameras, doorbells, dashcams, phrasebook recognizers | [Luckfox Pico](https://www.luckfox.com/Luckfox-Pico/EN-Luckfox-Pico), [Luckfox Pico Pro/Max](https://wiki.luckfox.com/Luckfox-Pico-Pro-Max/) |
| **2. Embedded edge** | Raspberry Pi 5, Jetson Orin Nano, Coral | 1-16 GB. Pi 5 comes in 1-16 GB, Orin Nano Super has 8 GB. | **2-25 W (corrected; Orin Nano is 7-25 W)** | 10 MB - 4 GB | Live vision, ASR, small LLMs/VLMs, drones, robots | [Raspberry Pi 5](https://www.raspberrypi.com/products/raspberry-pi-5/), [Jetson Orin Nano Super](https://www.nvidia.com/en-us/autonomous-machines/embedded-systems/jetson-orin/nano-super-developer-kit/) |
| **3. Personal devices** | Phones, AR glasses, NPU laptops | 8-32 GB | ~5-30 W | ~1-8B-parameter models, quantized | Offline translation, assistants | approximate |
| **4. On-prem GPU servers** | Workstation GPU, Tammy in LM Studio | 24-128 GB of GPU memory | 300-1,500 W | 7-70B parameters | Private LLMs, fine-tuning | approximate |
| **5. Cloud** | Data-center clusters | terabytes | megawatts | hundreds of billions of parameters and up | Frontier models, i.e. **the teachers** | approximate |

Coral, STM32H7, i.MX RT, SigmaStar, Ambarella and Allwinner V851 were not individually verified. Their figures are approximate.

## Corrections from the first draft
- **1c** was "8-64 MB". Real parts carry ~0.5-10 MB on chip, so the 16-64 MB band actually starts at **1d**.
- **1b**: "16 MB" only applies with external PSRAM or flash.
- **Tier 2** power tops out around 25 W (Jetson), not 15 W.
- The Arduino Nano 33 BLE Sense (Rev1) is marked End of Life. Use the Rev2.

## Rules of thumb
- **~1000x per big step** (KB → MB → GB → TB) in memory, with power following loosely. This is a heuristic, not a law.
- **Distillation + quantization move a capability down a tier.** int8 is about 4x smaller than float32.
- **Cascade:** a lower tier screens the input and wakes the higher tier only on a flag (wake-word chip → phone → cloud).
- **Crib + narrow action:** the tiny model raises a flag, reversible actions fire immediately, and irreversible ones get confirmed by a bigger model or a human. See [user-stories.md](user-stories.md).

## History note: edge control before "edge AI"
- **Lotus active suspension.** Lotus raced the first active-suspension F1 car, the Lotus 92, in 1983, and revived the system on the 99T in 1987, when Senna won Monaco and Detroit ([Motor Sport](https://www.motorsportmagazine.com/articles/single-seaters/f1/rise-active-suspension/), [F1-fansite](https://www.f1-fansite.com/glossary/active-suspension/)). A Lotus history site says the early control electronics used a **TI TMS1000** single-chip microcontroller ([projectm71](https://www.projectm71.com/Active.html), an enthusiast source).
- **Williams FW14B.** It dominated 1992 with active suspension, traction control and semi-automatic gearbox, and the FIA banned active suspension from 1994 ([Wikipedia](https://en.wikipedia.org/wiki/Williams_FW14B), [RaceFans](https://www.racefans.net/2007/05/17/banned-active-suspension/)).
- **DSPs.** TI introduced the TMS320 DSP family with the TMS32010 on April 8, 1983. Its fast multiply-accumulate is the same operation neural accelerators do today, and the C2000 descendants run motor and inverter control, for example in the Tesla Model 3 drive inverter ([Wikipedia](https://en.wikipedia.org/wiki/Texas_Instruments_TMS320)).
- *Not verified:* which specific processors Williams used. No claim is made that the FW14B used a TMS320.
