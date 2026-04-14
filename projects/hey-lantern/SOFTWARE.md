# Software — Hey Lantern

## Base Image

Raspberry Pi OS Bookworm Lite (64-bit, headless)
Pi hostname: `hey-lantern`, user: `pi`

## Architecture Overview

All wake-word detection runs locally on the Pi to keep latency low and avoid constant cloud
traffic. Everything after the wake word is detected is handed off to cloud services:

```
[Mic] → wake word engine (local, Pi Zero 2W)
           └── on trigger → record utterance → STT (cloud)
                                └── transcript → Claude API (cloud)
                                                    └── response text → TTS (cloud)
                                                                          └── audio → speakers
```

LED states track pipeline stage: idle pulse → listening → processing → speaking → idle.

## Wake Word Engine

**Decision open** — two viable options (see DECISIONS.md ADR-001 once filed):

| Option | Pros | Cons |
|--------|------|------|
| **openWakeWord** | Fully open source, customizable, free, runs on Pi Zero 2W | Requires training a custom model for "Hey Lantern"; setup is more involved |
| **Picovoice Porcupine** | Custom wake word via web console (no training), easy Python SDK, free tier (1 wake word) | Proprietary; free tier requires internet check-in |

Recommendation: start with Porcupine for faster bring-up; switch to openWakeWord if
licensing or offline requirements become a concern.

## Cloud Services

| Role | Service | Notes |
|------|---------|-------|
| STT | OpenAI Whisper API | High accuracy, cheap per-minute pricing |
| LLM | Anthropic Claude API | claude-haiku-4-5 for low latency responses |
| TTS | Google Cloud TTS or ElevenLabs | ElevenLabs has better voice quality; Google is cheaper |

All API keys stored in `/etc/hey-lantern/secrets.env` on the Pi, not in this repo.

## Key Dependencies

```bash
sudo apt-get install -y python3-pip python3-venv portaudio19-dev libsndfile1

pip install pvporcupine        # or openwakeword
pip install anthropic           # Claude API
pip install openai              # Whisper STT
pip install sounddevice soundfile numpy
pip install RPi.GPIO
```

## Application Structure (planned)

```
software/
├── main.py            # Main loop: wake word → record → STT → LLM → TTS → play
├── wake_word.py       # Wake word detection wrapper (Porcupine or openWakeWord)
├── stt.py             # Speech-to-text (Whisper API)
├── llm.py             # Claude API call with conversation context
├── tts.py             # Text-to-speech + audio playback
├── leds.py            # GPIO LED state controller
└── config.py          # Loads secrets.env, tunable parameters
```

## Configuration

Config files live in `config/` and deploy to the Pi via `scripts/deploy.sh`:

| File | Destination | Purpose |
|------|-------------|---------|
| `config/hey-lantern.service` | `/etc/systemd/system/` | Systemd unit — start on boot |
| `config/secrets.env.example` | `/etc/hey-lantern/` | API key template (no real keys in repo) |
| `config/audio.conf` | `/etc/asound.conf` | ALSA config for I2S mic + amp routing |

## SSH Access

```bash
ssh -i ~/.ssh/pi_key pi@hey-lantern.local
```

## Provisioning (Fresh Flash)

After flashing Bookworm Lite with hostname `hey-lantern` and SSH key configured:

```bash
bash projects/hey-lantern/scripts/setup.sh
```

## Deploy Config Changes

After modifying any file in `config/`:

```bash
bash projects/hey-lantern/scripts/deploy.sh
```

## Reference

- [antique-telephone-ai-operator](../antique-telephone-ai-operator/) — similar Claude API
  voice pipeline on Pi 5; check its software setup for patterns to reuse
- Porcupine Python SDK: https://github.com/Picovoice/porcupine
- openWakeWord: https://github.com/dscripka/openWakeWord
- Anthropic Python SDK: https://github.com/anthropics/anthropic-sdk-python
