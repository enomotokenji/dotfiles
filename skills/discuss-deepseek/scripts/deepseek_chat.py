#!/usr/bin/env python3
"""DeepSeek API chat script (OpenAI-compatible endpoint).

Usage:
    python3 deepseek_chat.py "<prompt>"

Reads DEEPSEEK_API_KEY from (in order):
  1. the environment
  2. $PWD/.env
  3. $HOME/.env
"""

import json
import os
import sys
import urllib.request
import urllib.error


ENV_KEY = "DEEPSEEK_API_KEY"
DEEPSEEK_API_URL = "https://api.deepseek.com/chat/completions"

MODEL_PREFERENCE = [
    "deepseek-reasoner",
    "deepseek-chat",
]


def load_api_key() -> str:
    if os.environ.get(ENV_KEY):
        return os.environ[ENV_KEY].strip()

    candidates = [
        os.path.join(os.getcwd(), ".env"),
        os.path.join(os.path.expanduser("~"), ".env"),
    ]
    for env_path in candidates:
        if not os.path.exists(env_path):
            continue
        with open(env_path) as f:
            for line in f:
                line = line.strip()
                if line.startswith(f"{ENV_KEY}="):
                    return line.split("=", 1)[1].strip().strip('"').strip("'")

    print(
        f"ERROR: {ENV_KEY} not found in environment or .env "
        f"($PWD/.env, $HOME/.env)",
        file=sys.stderr,
    )
    sys.exit(1)


def pick_best_model(api_key: str) -> str:
    url = "https://api.deepseek.com/models"
    try:
        req = urllib.request.Request(url, headers={"Authorization": f"Bearer {api_key}"})
        with urllib.request.urlopen(req, timeout=15) as resp:
            data = json.loads(resp.read().decode())
    except Exception as e:
        print(f"WARNING: listing models failed ({e}); using deepseek-chat", file=sys.stderr)
        return "deepseek-chat"

    available = {m.get("id", "") for m in data.get("data", [])}
    for pref in MODEL_PREFERENCE:
        if pref in available:
            print(f"Selected model: {pref}", file=sys.stderr)
            return pref
    return "deepseek-chat"


def call_deepseek(api_key: str, model: str, prompt: str) -> str:
    payload = {
        "model": model,
        "messages": [{"role": "user", "content": prompt}],
        "temperature": 0.7,
        "max_tokens": 8192,
    }
    req = urllib.request.Request(
        DEEPSEEK_API_URL,
        data=json.dumps(payload).encode("utf-8"),
        headers={
            "Content-Type": "application/json",
            "Authorization": f"Bearer {api_key}",
        },
        method="POST",
    )
    try:
        with urllib.request.urlopen(req, timeout=120) as resp:
            data = json.loads(resp.read().decode())
    except urllib.error.HTTPError as e:
        body = e.read().decode() if e.readable() else str(e)
        print(f"DeepSeek API error ({e.code}): {body}", file=sys.stderr)
        sys.exit(1)

    choices = data.get("choices", [])
    if choices:
        return choices[0].get("message", {}).get("content", "")
    return json.dumps(data, indent=2)


def main():
    if len(sys.argv) < 2:
        print("Usage: python3 deepseek_chat.py '<prompt>'", file=sys.stderr)
        sys.exit(1)
    prompt = sys.argv[1]
    api_key = load_api_key()
    model = pick_best_model(api_key)
    print(call_deepseek(api_key, model, prompt))


if __name__ == "__main__":
    main()
