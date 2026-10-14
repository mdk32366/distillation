# Model types and how they're trained

> **Thesis:** the next ten years of AI are about miniaturizing AI applications: moving capabilities down the [hardware tiers](edge-ai-tiers.md) from cloud to pocket to sensor.

## 1. Model types

Models are grouped first by how they learn, then by what they predict.

| Type | Learns from | Predicts | How it's trained | Examples |
|---|---|---|---|---|
| **Regressor** (supervised) | Labeled examples with a numeric answer | A number | Minimize the gap between predicted and true numbers (squared error / RMS) | Linear regression, random forest regressor |
| **Classifier** (supervised) | Labeled examples with a category | A class plus probabilities | Minimize cross-entropy, a penalty for confident wrong answers | Logistic regression, decision trees, neural nets |
| **Clustering** (unsupervised) | Unlabeled data | Groups of similar items | Pull points toward group centers, or split/merge by similarity | k-means, hierarchical clustering |
| **Dimensionality reduction** (unsupervised) | Unlabeled data | A compressed summary of the data | Keep the most variation (PCA), preserve neighborhoods (t-SNE), or best reconstruct the input (autoencoder) | PCA, t-SNE, autoencoders |
| **Self-supervised / language model** | Raw text or images with parts hidden | The missing piece, e.g. the next token | Predict hidden or next tokens over billions of examples | GPT, BERT |
| **Reinforcement learning** | Rewards from trying actions | The best action to take | Trial and error to maximize total reward | AlphaGo, RLHF tuning of chatbots |
| **Distilled student** | A big teacher model's outputs | Whatever the teacher predicts | Match the teacher's soft probabilities, not just the hard labels | DistilBERT, TinyML models |
| **Fine-tuned model** | A pretrained model plus a small labeled set | A specialized version of the original | Continue training the pretrained model briefly on new examples, often with LoRA | LoRA fine-tunes of open LLMs |

**Caruana note:** in Bucila/Caruana/Niculescu-Mizil 2006 model compression, the student is trained as a **regressor** that mimics a **classifier's** probabilities. The ensemble's class probabilities become numeric targets, which is the seed of Hinton's later "soft targets." See [papers/REFERENCES.md](../papers/REFERENCES.md).

**Common thread:** pick a loss that scores how wrong the model is, then nudge the weights to make it smaller. What varies from row to row is where the "right answer" comes from: humans (labels), the data itself (hidden tokens, structure), rewards, or a teacher model.

## 2. Miniaturizing each type

Shrinking toolbox: **distillation** (big teacher → small student), **quantization** (float32 → int8 is ~4x smaller; int4 ~8x), **pruning** (drop near-zero weights, neurons or whole trees), **low-rank factorization** (replace a big weight matrix with two thin ones), **small architectures** (MobileNet, TinyBERT, DistilBERT), and **compiling** simple models straight to C. Tiers refer to [edge-ai-tiers.md](edge-ai-tiers.md).

| Type | Main shrinking techniques | Realistic target tier |
|---|---|---|
| **Regressor** | Linear models are already tiny; distill forests into one shallow tree or small net; prune trees; compile trees to plain C if/else code; int8 | **1a Tiny MCU** |
| **Classifier** | Distill into a small tree or small net; int8 quantize; prune; compile trees to C; MobileNet-style nets for images | **1a-1c** (sensor/keyword on 1a-1b, vision on 1b-1c) |
| **Clustering** | Trivially small: k-means at inference is just storing k centroids and computing distances; quantize centroids | **1a Tiny MCU** |
| **Dimensionality reduction** | PCA is one small matrix multiply (trivially small); shrink autoencoders with pruning + int8; t-SNE is offline visualization, not deployed | **1a** (PCA), **1b-1c** (autoencoders, e.g. anomaly detection) |
| **Self-supervised / language model** | Distillation (DistilBERT, TinyBERT), int8/int4 quantization, pruning, low-rank factorization, smaller architectures | **1c-1d** for keyword/phrase models, **2-3** for small LLMs (~1-8B quantized) |
| **Reinforcement learning** | Distill the learned policy into a small net or tree (policy distillation); int8; train big in simulation, deploy small | **1b-2** (control loops on MCU, robots/drones on embedded edge) |
| **Distilled student** | Already the shrunk form; stack quantization + pruning on top | One tier below its teacher, often **1a-1c** |
| **Fine-tuned model** | LoRA keeps the trainable part tiny; merge adapters, then quantize (int4/int8); or distill the fine-tune into a smaller base | **2-4** (Tier 4 to train, Tier 2-3 to run quantized) |

Rule of thumb from the tiers page: distillation + quantization move a capability down roughly one tier.
