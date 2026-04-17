from config import TTS_ENABLED, WAKE_WORD_MODEL, WAKE_WORD_THRESHOLD
from llm import Session
from stt import record, transcribe
from tts import speak
from wake_word import WakeWordDetector

_GOODBYE = {"bye", "goodbye", "see you", "that's all", "stop"}


def main() -> None:
    print(f"[hey-lantern] wake word: '{WAKE_WORD_MODEL}'")

    detector = WakeWordDetector(WAKE_WORD_MODEL, WAKE_WORD_THRESHOLD)
    session = Session()

    print("[hey-lantern] listening...")

    while True:
        detector.listen()
        print("[hey-lantern] wake word detected")

        audio = record()
        transcript = transcribe(audio)
        if not transcript:
            continue

        print(f"[stt] {transcript!r}")

        if any(phrase in transcript.lower() for phrase in _GOODBYE):
            if TTS_ENABLED:
                speak("Goodbye!")
            session.reset()
            print("[hey-lantern] session ended, listening...")
            continue

        reply = session.ask(transcript)
        print(f"[llm] {reply!r}")
        if TTS_ENABLED:
            speak(reply)


if __name__ == "__main__":
    main()
