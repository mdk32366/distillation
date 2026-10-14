# User-story catalog: tiny models paired with devices

Each story follows **As a ___, I want ___ so that ___**, and is paired with a sensor, a model task, a target tier (see [edge-ai-tiers.md](edge-ai-tiers.md)), a **discrete trigger (the crib)** and a **narrow action**. The rule: the tiny model raises the flag, and anything irreversible gets confirmed by a bigger model or a human.

**Demand-analysis fields** (Market size / Competitors / Regulatory burden / Solo-builder feasibility) are deliberately **TBD**. No market numbers are invented here.

Fields per story: Story · Sensors · Model task · Tier · Trigger → Action · Notes/sources · Demand: Market TBD | Competitors TBD | Regulatory TBD | Solo feasibility TBD

---
## 1. Medical
> Anything that doses, stimulates or diagnoses is a regulated medical device (FDA). Research and hobby prototypes must not drive therapy.

**M1. Type 1 diabetes: on-device hypo prediction.** *As a parent of a T1D kid, I want a glucose-trend model on the sensor/watch that warns before a low, even with the phone out of range, so that we act 20+ minutes early.*
- Sensors: CGM stream (5-min readings), accelerometer (activity), time of day
- Model: short-horizon glucose forecasting (tiny RNN/TCN)
- Tier: 1b/1c (watch or receiver)
- Trigger → Action: predicted <55 mg/dL within 20 min → alert parent and child (reversible). Insulin changes stay with the cleared closed-loop system.
- Existing products (verified): Dexcom G7 already has an "Urgent Low Soon" alert that predicts 55 mg/dL within 20 min ([Dexcom FAQ](https://www.dexcom.com/en-us/faqs/how-does-the-urgent-low-soon-alert-work)). Tandem Control-IQ+ is an FDA Class II interoperable automated glycemic controller (21 CFR 862.1356) that adjusts insulin from iCGM input ([FDA K250798](https://www.accessdata.fda.gov/cdrh_docs/pdf25/K250798.pdf)). Omnipod 5 integrates with Dexcom G7 ([DiabetesWise](https://diabeteswise.org/device-finder/compare/dexcom-g7/omnipod-5)).
- Open angle: personalization, caregiver-side context (sports, illness, sleep), explaining *why* an alert fired.
- Demand: Market TBD | Competitors: Dexcom, Tandem, Insulet + TBD | Regulatory: high if it alerts on therapy | Solo feasibility TBD (a non-diagnostic "data companion" is the realistic entry)

**M2. Wearable/portable dialysis: safety monitoring.** *As a dialysis patient on a portable device, I want continuous anomaly detection on pressure, flow and fluid balance so that leaks, clots or air are caught instantly.*
- Reality check (verified): wearable kidneys are **investigational, not approved**. AWAK PD (wearable peritoneal dialysis, ~3 kg) has FDA Breakthrough designation, and its pre-pivotal study of 11 subjects reported no device-related serious adverse events ([JASN 2024](https://journals.lww.com/jasn/fulltext/2024/10001/prepivotal_study_exploring_safety,_efficacy,_and.69.aspx)). An earlier wearable hemodialysis trial worked for 24 h but needed redesign ([PMC4936831](https://pmc.ncbi.nlm.nih.gov/articles/PMC4936831/)). Nephrodite's implantable Holly got Breakthrough designation in Dec 2025, with human trials ~20-24 months out ([Nephrodite](https://nephrodite.com/newsroom/nephrodite-earns-fdas-first-breakthrough-device-designation-for-an-implantable-kidney-replacement-system/), [Healio](https://www.healio.com/news/nephrology/20260129/a-bridge-to-transplant-implantable-dialysis-device-receives-fda-breakthrough-status)).
- Sensors: line pressure, flow, bubble/optical, weight/UF volume
- Model: anomaly detection on time series
- Tier: 1a/1b, embedded in the device
- Trigger → Action: pressure/flow signature out of envelope → pause pump (safe-state) and alarm. Resuming takes a human.
- Demand: all TBD. **Solo feasibility: low.** The opening is a partnership, not a product.

**M3. Migraine: prodrome prediction + onset detection.** *As a migraine sufferer, I want my wearable to flag a likely attack the night before or at onset so that I take medication or start neuromodulation early.*
- Evidence (verified, small studies): nocturnal HRV, EDA, skin temperature and motion show individualized pre-migraine patterns. Studies with 7-23 people report ~80%+ accuracy with personalized models, but the results are preliminary ([PMC5981434](https://pmc.ncbi.nlm.nih.gov/articles/PMC5981434/), [Healthcare 2024](https://www.mdpi.com/2227-9032/12/17/1701), [PubMed 41607086](https://pubmed.ncbi.nlm.nih.gov/41607086/)).
- Existing devices: Nerivio, an Rx arm-worn remote electrical neuromodulation device for ages 8+ ([nerivio.com](https://www.nerivio.com/), [FDA K250405](https://www.accessdata.fda.gov/scripts/cdrh/cfdocs/cfPMN/pmn.cfm?ID=K250405)). Cefaly, an OTC forehead e-TNS device for adults ([Cefaly](https://www.cefaly.com/blog/nerivio-vs-eneura-vs-cefaly/)).
- Model: personalized classifier (on-device fine-tune or LoRA-style adapter)
- Tier: 1b/1c wearable, 3 phone for training
- Trigger → Action: risk > threshold → nudge ("hydrate, sleep, have meds ready"). Starting stimulation stays the user's choice.
- Demand: all TBD. Lower regulatory risk if it's framed as a wellness insight rather than a diagnosis.

**M4. Fall detection for elders.** *As an adult child, I want a pendant that detects a hard fall and no-get-up so that help comes fast.* IMU → fall + inactivity classifier → 1a → fall + 60 s still → call/alert (cancelable). Demand: TBD.

---
## 2. Mechanical / Automotive
**A1. Semi-active suspension control.** *As a vehicle/e-bike builder, I want a learned controller that adjusts damping for the road ahead so that ride and grip improve.* Accelerometers, wheel travel, speed → road-class/bump prediction → 1b/1c → class change → damper setpoint (bounded, fail-soft). Heritage: see the F1 history note in the tiers doc. Demand: TBD.

**A2. NVH / vibration fault detection.** *As a fleet mechanic, I want a clip-on sensor that recognizes wheel bearing, CV joint or driveline signatures so that I catch failures early.* IMU + mic → anomaly + fault class → 1a/1b → signature persistent over N trips → service ticket. Demand: TBD.

**A3. Engine knock / misfire.** *As a tuner, I want ML knock detection from a knock sensor or mic that's robust to noise so that I can run closer to the limit safely.* Knock sensor → spectrogram classifier → 1c (DSP-class latency) → knock → retard timing (reversible, bounded). Demand: TBD (ECUs already do this classically, so the question is incremental value).

**A4. E-bike / drone motor health + tire/brake wear.** *As a rider/operator, I want a warning when bearing, winding or brake signatures change so that I service before a failure.* Phase current, IMU, temperature → anomaly → 1a/1b → drift beyond baseline → advisory. Demand: TBD.

---
## 3. Industrial / Chemical
**I1. Pump & gearbox predictive maintenance.** *As a plant engineer, I want vibration nodes on pumps and gearboxes that flag cavitation or gear wear so that I schedule repairs.* IMU/acoustic → anomaly → 1a → alert. Irreversible action (shutdown) needs an operator. Demand: TBD.

**I2. Gas leak / acoustic leak detection.** *As an operator, I want gas-sensor plus ultrasonic leak recognition that ignores false triggers so that real leaks get isolated quickly.* MOX/electrochemical gas arrays + ultrasonic mic → classifier → 1b → confirmed signature → alarm. Closing valves stays with the safety-instrumented system. Demand: TBD (safety-certified territory).

**I3. Reactor / process anomaly.** *As a process engineer, I want a local model that spots temperature/pressure trajectories drifting from the batch "golden profile" so that I intervene early.* Process tags → sequence anomaly → 1d/2 at the PLC → flag to the operator. Demand: TBD.

**I4. HVAC fault detection & corrosion.** *As a facilities manager, I want compressor/fan anomaly and corrosion-sensor trend alerts so that I avoid outages.* Current, vibration, corrosion probes → anomaly → 1a → work order. Demand: TBD.

---
## 4. Farming
**F1. Pest detection.** *As a grower, I want insect-trap cameras or wingbeat-audio sensors that identify target pests so that I spray only where needed.* Camera/mic → classifier → 1c/1d → count > threshold → map alert. Demand: TBD.

**F2. Livestock health.** *As a rancher, I want collars that detect lameness, rumination drop or estrus so that I treat early.* IMU + mic → activity/behavior classifier → 1a → deviation → phone alert. Demand: TBD.

**F3. Smart irrigation & crop disease.** *As a farmer, I want soil-moisture-plus-leaf-image nodes that decide when to water and flag disease so that I save water and catch blight.* Soil probes, camera → regression + classifier → 1b/1d → open valve for N min (bounded), disease → human review. Demand: TBD.

---
## 5. Aerospace
**X1. Structural health monitoring.** *As an MRO engineer, I want acoustic-emission/strain nodes that flag crack-growth signatures so that inspections are targeted.* AE sensors → event classifier → 1b/1c → logged flag → inspection (human). Demand: TBD (certification-heavy).

**X2. Engine / rotor vibration.** *As a UAV or GA operator, I want onboard vibration signature tracking so that I see imbalance or bearing wear before failure.* IMU → anomaly → 1a/1b → advisory. Demand: TBD.

**X3. UAV autonomy.** *As a drone builder, I want onboard obstacle and landing-zone detection so that it works without a link.* Camera/ToF → detection → 1d/2 → avoidance maneuver (bounded). Demand: TBD.

**X4. Satellite onboard inference.** *As a smallsat operator, I want cloud screening and event detection in orbit so that I downlink only useful frames.* Imager → classifier → 1d/2 (rad-tolerant) → keep/discard frame. This is the cascade pattern in space. Demand: TBD.

---
## 6. Weather
**W1. Micro weather station with local nowcasting.** *As a farmer/event organizer, I want a station that predicts rain or gusts in the next 30-60 min so that I act locally.* Pressure, humidity, temperature, wind → short-horizon forecast → 1b → alert. Demand: TBD.

**W2. Lightning / hail detection.** *As a homeowner or golf course, I want acoustic/RF/optical detection of hail onset or nearby lightning so that people and gear get covered.* Mic (hail impacts), RF sferics sensor → classifier → 1a/1b → siren/alert. Demand: TBD.

**W3. Sky-camera nowcasting.** *As a solar-farm operator, I want cloud-motion prediction from a sky camera so that I ramp storage before shading.* Fisheye camera → motion/occlusion model → 1d → dispatch hint. Demand: TBD.

---
## 7. Consumer / Other
**C1. Hearing aids / earbuds.** Speech-in-noise enhancement, own-voice and keyword detection. Mic array → 1a/1c. Demand: TBD.

**C2. Wildlife / gunshot / chainsaw detection.** *As a ranger, I want solar acoustic nodes that report chainsaws or gunshots so that patrols respond.* Mic → classifier → 1a/1b → GPS-tagged alert. Demand: TBD.

**C3. Privacy camera.** *As a homeowner, I want a camera that only says "person/package present" and never uploads video.* 1c/1d → event only. Demand: TBD.

**C4. Phrasebook translator.** *As a traveler or medic, I want offline recognition of a few hundred fixed phrases in 1-2 languages so that I communicate without a network.* Mic → phrase classifier + canned audio → 1c/1d. Full translation needs tier 3. Demand: TBD.

---
## Next steps
1. Fill in the demand fields (market, competitors, regulatory, feasibility) for the top picks in each domain.
2. Shortlist 2-3 stories, then pick one solo-buildable target for step 5.
