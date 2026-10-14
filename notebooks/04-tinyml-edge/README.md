# Step 5: TinyML / AIoT edge deployment (placeholder)

**Goal:** distill a tiny student model, compress it, and run it on a cheap microcontroller with no cloud.

## Pipeline
1. **Teacher:** train a larger model on a laptop (as in steps 2-3).
2. **Distill:** train a tiny student on the teacher's soft targets (temperature).
3. **Compress:**
   - Post-training **int8 quantization** (weights and activations as 8-bit integers, about 4x smaller than float32)
   - Optional **pruning** (remove near-zero weights), then fine-tune to recover accuracy
4. **Convert:** export to a `.tflite` flatbuffer and then to a C array (`xxd -i model.tflite > model.cc`)
5. **Deploy:** run it with **TensorFlow Lite for Microcontrollers (LiteRT for Microcontrollers)** on a board such as the **ESP32-S3** or **Arduino Nano 33 BLE Sense**

## Starter project (pick one)
- **Keyword spotting:** detect "yes"/"no" or a custom wake word from a microphone (Speech Commands dataset). This is the classic TinyML first project.
- **Accelerometer gesture or anomaly detection:** classify motions (for example a wand gesture), or flag unusual vibration on a motor or fan. This is the most "IoT" option.

## Size budget (rough targets, not hard limits)
| Resource | Target |
|---|---|
| Model (flash) | under ~100-250 KB |
| Working memory (RAM / tensor arena) | under ~256 KB |
| Latency | real-time for the sensor (for example under ~100 ms per audio window) |
| Power | battery-friendly, always on |

Compare float32 and int8 on size, accuracy and latency, and record the accuracy cost of each compression step.

## AIoT framing
Classic IoT shipped raw sensor data to the cloud, which cost bandwidth, battery and privacy. With TinyML **the sensor decides locally** and **only reports events** ("keyword heard", "abnormal vibration"). The result is less traffic, longer battery life, more privacy, and it keeps working offline.

## See also
- [Edge AI hardware tiers](../../docs/edge-ai-tiers.md): which chip tier a model fits on, with verified memory and power figures
- [User-story catalog](../../docs/user-stories.md): candidate applications by domain, to pick a target project

## Reading list
- Warden & Situnayake, *TinyML* (O'Reilly, 2019), book site: https://tinymlbook.com/
- LiteRT (TensorFlow Lite) for Microcontrollers docs: https://ai.google.dev/edge/litert/microcontrollers/overview
- Banbury et al., "MLPerf Tiny Benchmark" (2021): https://arxiv.org/abs/2106.07597
- Han, Mao & Dally, "Deep Compression" (2015): https://arxiv.org/abs/1510.00149
- Jacob et al., "Quantization and Training of Neural Networks for Efficient Integer-Arithmetic-Only Inference" (2017): https://arxiv.org/abs/1712.05877

## Hardware shopping note (nothing purchased)
- **ESP32-S3 dev board** (for example with a PDM mic or camera): cheap, has Wi-Fi/BLE, and has vector instructions for ML
- **Arduino Nano 33 BLE Sense** (Rev2): onboard mic, IMU and other sensors, and the board used in the TinyML book
- Optional: USB cable, breadboard, and a small LiPo battery for always-on tests
