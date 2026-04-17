import numpy as np
import sounddevice as sd
from openwakeword.model import Model

# openWakeWord expects 80ms frames at 16kHz
CHUNK_SAMPLES = 1280


class WakeWordDetector:
    def __init__(self, model: str, threshold: float = 0.5):
        self.model_name = model
        self.threshold = threshold
        self._oww = Model(wakeword_models=[model], inference_framework="onnx")

    def listen(self) -> None:
        """Block until the wake word is detected."""
        with sd.InputStream(samplerate=16000, channels=1, dtype="int16") as stream:
            while True:
                audio, _ = stream.read(CHUNK_SAMPLES)
                chunk = np.squeeze(audio)
                scores = self._oww.predict(chunk)
                if float(scores.get(self.model_name, 0)) >= self.threshold:
                    return
