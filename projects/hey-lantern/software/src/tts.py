import io

import sounddevice as sd
import soundfile as sf
from openai import OpenAI

from config import OPENAI_API_KEY

_client = OpenAI(api_key=OPENAI_API_KEY)


def speak(text: str, voice: str = "alloy") -> None:
    response = _client.audio.speech.create(
        model="tts-1",
        voice=voice,
        input=text,
        response_format="wav",
    )

    buf = io.BytesIO(response.content)
    data, samplerate = sf.read(buf)
    sd.play(data, samplerate)
    sd.wait()
