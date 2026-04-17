import io

import numpy as np
import sounddevice as sd
import soundfile as sf
from openai import OpenAI

from config import OPENAI_API_KEY, SAMPLE_RATE, RECORD_SECONDS

_client = OpenAI(api_key=OPENAI_API_KEY)


def record() -> np.ndarray:
    """Record a fixed-duration utterance from the microphone."""
    audio = sd.rec(
        int(RECORD_SECONDS * SAMPLE_RATE),
        samplerate=SAMPLE_RATE,
        channels=1,
        dtype="int16",
    )
    sd.wait()
    return audio


def transcribe(audio: np.ndarray) -> str:
    buf = io.BytesIO()
    sf.write(buf, audio, SAMPLE_RATE, format="WAV", subtype="PCM_16")
    buf.seek(0)
    buf.name = "audio.wav"

    result = _client.audio.transcriptions.create(model="whisper-1", file=buf)
    return result.text.strip()
