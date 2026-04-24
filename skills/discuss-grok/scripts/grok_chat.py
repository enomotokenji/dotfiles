#!/usr/bin/env python3
"""xAI Grok API chat script (OpenAI-compatible endpoint).

Usage:
    python3 grok_chat.py "<prompt>"

Reads XAI_API_KEY from (in order):
  1. the environment
  2. $PWD/.env
  3. $HOME/.env
"""

import json
import os
import sys
import urllib.request
import urllib.error


ENV_KEY = "XAI_API_KEY"
XAI_API_URL = "https://api.x.ai/v1/chat/completions"

MODEL_PREFERENCE = [
    "grok-4.20-0309-reasoning",
    "grok-4.20-0309-non-reasoning",
    "grok-4-1-fast-reasoning",
    "grok-4-1-fast-non-reasoning",
    "grok-4-fast-reasoning",
    "grok-4-fast-non-reasoning",
    "grok-4-0709",
    "grok-3",
    "grok-3-mini",
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
    url = "https://api.x.ai/v1/models"
    try:
        req = urllib.request.Request(
            url,
            headers={
                "Authorization": f"Bearer {api_key}",
                "User-Agent": "grok-chat/1.0",
            },
        )
        with urllib.request.urlopen(req, timeout=15) as resp:
            data = json.loads(resp.read().decode())
    except Exception as e:
        print(f"WARNING: listing models failed ({e}); using grok-3-mini-fast", file=sys.stderr)
        return "grok-3-mini-fast"

    available = {m.get("id", "") for m in data.get("data", [])}
    for pref in MODEL_PREFERENCE:
        if pref in available:
            print(f"Selected model: {pref}", file=sys.stderr)
            return pref

    for model_id in sorted(available):
        if "grok" in model_id.lower():
            print(f"Selected model: {model_id}", file=sys.stderr)
            return model_id
    return "grok-3-mini-fast"


def call_grok(api_key: str, model: str, prompt: str) -> str:
    payload = {
        "model": model,
        "messages": [{"role": "user", "content": prompt}],
        "temperature": 0.7,
        "max_tokens": 8192,
    }
    req = urllib.request.Request(
        XAI_API_URL,
        data=json.dumps(payload).encode("utf-8"),
        headers={
            "Content-Type": "application/json",
            "Authorization": f"Bearer {api_key}",
            "User-Agent": "grok-chat/1.0",
        },
        method="POST",
    )
    try:
        with urllib.request.urlopen(req, timeout=120) as resp:
            data = json.loads(resp.read().decode())
    except urllib.error.HTTPError as e:
        body = e.read().decode() if e.readable() else str(e)
        print(f"xAI Grok API error ({e.code}): {body}", file=sys.stderr)
        sys.exit(1)

    choices = data.get("choices", [])
    if choices:
        return choices[0].get("message", {}).get("content", "")
    return json.dumps(data, indent=2)


def main():
    if len(sys.argv) < 2:
        print("Usage: python3 grok_chat.py '<prompt>'", file=sys.stderr)
        sys.exit(1)
    prompt = sys.argv[1]
    api_key = load_api_key()
    model = pick_best_model(api_key)
    print(call_grok(api_key, model, prompt))


if __name__ == "__main__":
    main()
