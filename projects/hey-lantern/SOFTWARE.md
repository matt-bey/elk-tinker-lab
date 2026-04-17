# Software — Hey Lantern

## Base Image

Raspberry Pi OS Bookworm Lite (64-bit, headless)
Pi hostname: `elkpi02`, user: `matt`

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

**Decision: openWakeWord** — fully open source, offline, Apache 2.0.

POC uses the pre-trained `hey_jarvis` model as a stand-in. Final build will use a custom
"Hey Lantern" `.onnx` model (generated via openWakeWord's training pipeline, or swap to
Picovoice Porcupine if the custom model proves unreliable).

Set `WAKE_WORD_MODEL` in `.env` to a pre-trained model name or path to a `.onnx` file.

## Cloud Services

| Role | Service | Notes |
|------|---------|-------|
| STT | OpenAI Whisper API | High accuracy, cheap per-minute pricing |
| LLM | Anthropic Claude API | claude-haiku-4-5 for low latency responses |
| TTS | OpenAI TTS API | Same API key as Whisper; sufficient for POC. Swap to ElevenLabs for better voice quality in final build. |

API keys stored in `~/hey-lantern/.env` on the Pi (deployed via `deploy-software.sh`, never committed).

## Key Dependencies

System packages (Pi only — not needed on Mac):
```bash
sudo apt-get install -y portaudio19-dev libsndfile1
```

Python dependencies are managed with `uv` (see `software/pyproject.toml`):
```bash
cd projects/hey-lantern/software
uv sync
```

## Application Structure

```
software/
├── pyproject.toml     # uv-managed dependencies
├── .python-version    # pins Python 3.11
├── .env               # API keys + config (not in repo — copy from .env.example)
├── .env.example       # template
└── src/
    ├── main.py        # Main loop: wake word → record → STT → LLM → TTS → play
    ├── wake_word.py   # openWakeWord detection
    ├── stt.py         # Whisper API transcription
    ├── llm.py         # Claude API with conversation session context
    ├── tts.py         # OpenAI TTS + sounddevice playback
    └── config.py      # Loads .env, constants
```

Run the POC:
```bash
cd projects/hey-lantern/software
cp .env.example .env  # then fill in API keys
uv run python src/main.py
```

## Configuration

Config files live in `config/` and deploy to the Pi via `scripts/deploy.sh`:

| File | Destination | Purpose |
|------|-------------|---------|
| `config/hey-lantern.service` | `/etc/systemd/system/` | Systemd unit — start on boot |
| `config/audio.conf` | `/etc/asound.conf` | ALSA config — USB capture device as default |

## SSH Access

```bash
ssh -i ~/.ssh/elkpi_key matt@elkpi02.local
```

## Provisioning (Fresh Flash)

After flashing Bookworm Lite with hostname `elkpi02` and SSH key configured:

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
- openWakeWord: https://github.com/dscripka/openWakeWord
- Anthropic Python SDK: https://github.com/anthropics/anthropic-sdk-python
