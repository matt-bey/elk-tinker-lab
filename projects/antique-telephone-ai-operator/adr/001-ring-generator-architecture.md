# ADR 001 — Ring Generator Architecture

**Status:** Proposed — pending HT802 ring voltage test  
**Date:** 2026-04-17

---

## Context

The antique Kellogg Chicago ringer requires **90V AC at 20Hz** to fully drive its mechanical clapper (two 800Ω coils in series = 1604Ω total). This is the standard POTS ring spec.

Sourcing a dedicated ring generator module has proven difficult and expensive:

| Option | Price | Issue |
|---|---|---|
| Sandman DSI9P | ~$70 | Standalone use unconfirmed — needs a call to verify |
| Black Magic (eBay) | ~$50 | eBay surplus, uncertain availability |
| Model Railroad Control Systems | ~$70 | Available but expensive |
| AliExpress DIY search | — | No suitable modules found; "ring generator" is too niche a term to surface cheaply |

A DIY ring generator (boost converter + transformer + H-bridge, as documented in [jonscheiding/phone-ringer](https://github.com/jonscheiding/phone-ringer)) was explored but that project explicitly failed to drive mechanical clappers on older phones — which is exactly this use case.

A Grandstream HT802 ATA (already owned) generates ring voltage from its FXS port and successfully rings a 1980s mechanical-ringer rotary phone "very loudly." The question is whether it outputs sufficient voltage and current to drive the Kellogg's higher-impedance 1604Ω ringer.

Additionally, the Pi software already implements a full SIP client, which opens the door to a fundamentally different architecture where the HT802 handles all telephony and the Pi focuses purely on AI.

---

## The Test

Before making an architectural decision, verify empirically whether the HT802 can ring the Kellogg.

### Step 1 — Find the terminal board on the Kellogg

The Kellogg Chicago wall telephone has a terminal board accessible from the bottom or back of the wooden cabinet. Open the cabinet (there is typically a latch or two screws on the bottom panel). Look for a strip of brass or steel binding posts — they are usually labeled:

- **L1** and **L2** — the telephone line (this is what you want)
- **B** — battery (used in the original magneto exchange system, ignore for this test)
- **G** or **GND** — ground (ignore for this test)

If the posts are unlabeled, photograph the internal wiring before touching anything. The ringer coils connect to L1/L2 through the internal wiring.

### Step 2 — Wire the HT802 to the Kellogg

You need a standard RJ11 phone cord. Cut or strip one end to expose the wires inside (or use a spare cord and alligator clips).

Inside a US phone cord, the two active wires are:
- **Red = Ring**
- **Green = Tip**

Connect Red and Green to L1 and L2 on the terminal board. Polarity does not matter for ringing.

Plug the uncut RJ11 end into **Port 1** on the HT802.

### Step 3 — Ring the phone

Call the number or SIP extension assigned to HT802 Port 1 from your cell phone or SIP client.

### What to look for

| Result | Meaning |
|---|---|
| Bell rings loudly | HT802 outputs sufficient voltage — proceed with HT802 architecture |
| Bell rings weakly (clapper moves but doesn't reach bells) | Voltage is marginal — same symptom seen at low voltage; dedicated module may be needed |
| No ring at all | HT802 ring voltage is insufficient for this ringer |

Also note: while off-hook (handset lifted), do you hear audio through the earpiece? This is a secondary test of whether the HT802 drives the 63Ω earpiece at usable volume.

---

## Architectural Options

### Option A — Current architecture (self-contained, no HT802)

```
Pi 5
 ├── Carbon mic → bias circuit → I2S ADC → Pi (mic input)
 ├── Pi audio out → LM386 module → earpiece (audio output)
 ├── Hook switch → GPIO
 ├── Crank → optocoupler → GPIO
 └── Ring generator module → relay → ringer coils
```

**Pros:**
- Fully self-contained — no external dependencies
- Easy to replicate and gift (one unit, self-contained kit)
- No VoIP subscription or network required

**Cons:**
- Ring generator is expensive ($50–80) and hard to source
- Requires building bias circuit, preamp, and signal conditioning circuits
- More hardware complexity overall

### Option B — HT802-integrated architecture

```
Pi 5 (SIP client + AI)
 └── SIP over LAN ──→ HT802
                         └── RJ11 ──→ Kellogg telephone
                                         ├── Ringer (HT802 drives directly)
                                         ├── Carbon mic (HT802 drives directly — POTS loop current)
                                         ├── Earpiece (HT802 drives directly)
                                         └── Hook switch (HT802 detects off-hook via loop current)
```

The Pi makes a SIP call to the HT802 to trigger ringing. When the handset is lifted, the HT802 detects off-hook and connects the SIP call. The Pi's AI layer handles STT → LLM → TTS within the call audio stream.

**Pros:**
- HT802 handles ring voltage, carbon mic bias, earpiece drive, hook detection — all solved in one $45 device
- No custom ring generator circuit needed
- Pi software is already a SIP client — this fits naturally
- Carbon mic bias (the 12V circuit) eliminated — POTS loop current handles it
- Significantly less custom circuitry overall
- A real phone number via a SIP trunk (e.g. Twilio ~$1/month) means anyone can call it

**Cons:**
- Requires HT802 per deployment (~$45 each) and a network connection
- Not fully self-contained — depends on LAN/router
- Replication means shipping/buying an HT802 alongside the telephone
- If HT802 ring voltage is insufficient for the Kellogg ringer, this approach fails at the core requirement

---

## Pending Questions

1. **Does the HT802 ring the Kellogg bell?** — answered by the test above
2. **What is the HT802's maximum configurable ring voltage?** — check the HT802 web admin at `http://192.168.x.x` → FXS Port → Ring Voltage setting (look for the max value in the dropdown or field)
3. **Is audio quality through the carbon mic acceptable via POTS loop current?** — answered by picking up the handset during the test call and speaking

---

## Decision

_To be made after the test._

- If the bell rings fully and audio is acceptable → **Option B (HT802 architecture)**
- If the bell does not ring sufficiently → **Option A (dedicated ring generator)**, resume Sandman DSI9P inquiry
