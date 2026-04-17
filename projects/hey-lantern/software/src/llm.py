import time

from anthropic import Anthropic

from config import ANTHROPIC_API_KEY, LLM_MODEL, SESSION_TIMEOUT, SYSTEM_PROMPT

_client = Anthropic(api_key=ANTHROPIC_API_KEY)


class Session:
    """Maintains conversation context across turns. Resets after SESSION_TIMEOUT seconds of inactivity."""

    def __init__(self):
        self.messages: list[dict] = []
        self._last_turn: float = 0.0

    def ask(self, user_text: str) -> str:
        if self.messages and (time.monotonic() - self._last_turn) > SESSION_TIMEOUT:
            print("[llm] session timed out — starting fresh")
            self.reset()

        self.messages.append({"role": "user", "content": user_text})

        response = _client.messages.create(
            model=LLM_MODEL,
            max_tokens=512,
            system=SYSTEM_PROMPT,
            messages=self.messages,
        )

        reply = response.content[0].text
        self.messages.append({"role": "assistant", "content": reply})
        self._last_turn = time.monotonic()
        return reply

    def reset(self) -> None:
        self.messages = []
        self._last_turn = 0.0
