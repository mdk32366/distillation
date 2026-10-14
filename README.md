# Distillation project
**Goal:** learn to train small models from big ones (knowledge distillation).

## Roadmap
1. **First model**: College Scorecard regression + classifier, Sat 10/17 10 AM. Files: `C:\Users\mdk32\Downloads\practice-dataset`
2. **Toy sklearn distillation**: `notebooks/01-toy-distillation.ipynb` (random-forest teacher, decision-tree students, temperature demo)
3. **MNIST small neural net with temperature**: the paper's own setup (`notebooks/02-mnist-temperature/`, placeholder)
4. **LoRA fine-tune a small LLM on big-model outputs** on the 8 GB RTX PRO 2000 (`notebooks/03-lora-llm/`, placeholder)

## Layout
- `papers/` `REFERENCES.md` with links to Hinton 2015 and Bucila/Caruana 2006 (PDFs not included; download into `papers/`)
- `notebooks/` exercises
- `requirements.txt`, `setup.bat`, `SETUP.md`
