# Distillation project
**Goal:** learn to train small models from big ones (knowledge distillation).

## Roadmap
1. **First model**: College Scorecard regression + classifier, Sat 10/17 10 AM. Files: `C:\Users\mdk32\Downloads\practice-dataset`
2. **Toy sklearn distillation**: `notebooks/01-toy-distillation.ipynb` (random-forest teacher, decision-tree students, temperature demo)
3. **MNIST small neural net with temperature**: the paper's own setup (`notebooks/02-mnist-temperature/`, placeholder)
4. **LoRA fine-tune a small LLM on big-model outputs** on the 8 GB RTX PRO 2000 (`notebooks/03-lora-llm/`, placeholder)
5. **TinyML / AIoT edge deployment**: distill a tiny student, int8-quantize/prune it, and deploy to an ESP32-S3 or Arduino Nano 33 BLE Sense with LiteRT for Microcontrollers (`notebooks/04-tinyml-edge/`, placeholder)

## Reference docs
- [docs/edge-ai-tiers.md](docs/edge-ai-tiers.md): hardware tiers by memory and power (MCU → cloud), with verified sources
- [docs/user-stories.md](docs/user-stories.md): user-story catalog across medical, mechanical, industrial, farming, aerospace, weather and consumer, with demand-analysis fields

## Layout
- `papers/` `REFERENCES.md` with links to Hinton 2015 and Bucila/Caruana 2006 (PDFs not included; download into `papers/`)
- `notebooks/` exercises
- `docs/` reference pages
- `requirements.txt`, `setup.bat`, `SETUP.md`
