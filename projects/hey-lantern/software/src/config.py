import os
from pathlib import Path
from dotenv import load_dotenv

load_dotenv(Path(__file__).parent.parent / ".env")

OPENAI_API_KEY = os.environ["OPENAI_API_KEY"]
ANTHROPIC_API_KEY = os.environ["ANTHROPIC_API_KEY"]

# Wake word — pre-trained model name or path to a custom .onnx file
WAKE_WORD_MODEL = os.getenv("WAKE_WORD_MODEL", "hey_jarvis")
WAKE_WORD_THRESHOLD = float(os.getenv("WAKE_WORD_THRESHOLD", "0.5"))

# Audio
SAMPLE_RATE = 16000
RECORD_SECONDS = 5  # fixed-duration recording; good enough for POC

# TTS — disable if no speaker is connected (response text still printed to console)
TTS_ENABLED = os.getenv("TTS_ENABLED", "true").lower() == "true"

# Conversation session
SESSION_TIMEOUT = int(os.getenv("SESSION_TIMEOUT", "30"))

# LLM
LLM_MODEL = "claude-haiku-4-5-20251001"
SYSTEM_PROMPT = (
    "You are Hey Lantern, a friendly voice assistant living inside a vintage Coleman camp lantern. "
    "Keep responses concise and conversational — you're speaking aloud, not writing. "
    "Aim for 1–3 sentences unless the question genuinely needs more."
)
