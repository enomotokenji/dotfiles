#!/usr/bin/env python3
"""Gemini API chat script.

Usage:
    python3 gemini_chat.py "<prompt>"

Reads GEMINI_API_KEY from (in order):
  1. the environment
  2. $PWD/.env
  3. $HOME/.env

Queries the model listing endpoint and selects the strongest available
Gemini model from MODEL_PREFERENCE. Timeout on generation is 120s.
"""

import json
import os
import sys
import urllib.request
import urllib.error


ENV_KEY = "GEMINI_API_KEY"

MODEL_PREFERENCE = [
    "gemini-3.5-pro",
    "gemini-3.5-flash",
    "gemini-3.0-pro",
    "gemini-3.0-flash",
    "gemini-2.5-pro",
    "gemini-2.5-flash",
    "gemini-2.0-pro",
    "gemini-2.0-flash",
    "gemini-1.5-pro",
    "gemini-1.5-flash",
]


def load_api_key() -> str:
    """Look for the API key in env first, then $PWD/.env, then $HOME/.env."""
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
    url = f"https://generativelanguage.googleapis.com/v1beta/models?key={api_key}"
    try:
        with urllib.request.urlopen(urllib.request.Request(url), timeout=15) as resp:
            data = json.loads(resp.read().decode())
    except Exception as e:
        print(f"WARNING: listing models failed ({e}); using gemini-2.5-pro", file=sys.stderr)
        return "gemini-2.5-pro"

    available_full = []
    for m in data.get("models", []):
        name = m.get("name", "").replace("models/", "")
        methods = m.get("supportedGenerationMethods", [])
        if "generateContent" in methods:
            available_full.append(name)

    for pref in MODEL_PREFERENCE:
        for name in available_full:
            if name.startswith(pref):
                print(f"Selected model: {name}", file=sys.stderr)
                return name
    return "gemini-2.5-pro"


def call_gemini(api_key: str, model: str, prompt: str) -> str:
    url = (
        f"https://generativelanguage.googleapis.com/v1beta/models/"
        f"{model}:generateContent?key={api_key}"
    )
    payload = {
        "contents": [{"parts": [{"text": prompt}]}],
        "generationConfig": {"temperature": 0.7, "maxOutputTokens": 8192},
    }
    req = urllib.request.Request(
        url,
        data=json.dumps(payload).encode("utf-8"),
        headers={"Content-Type": "application/json"},
        method="POST",
    )
    try:
        with urllib.request.urlopen(req, timeout=120) as resp:
            data = json.loads(resp.read().decode())
    except urllib.error.HTTPError as e:
        body = e.read().decode() if e.readable() else str(e)
        print(f"Gemini API error ({e.code}): {body}", file=sys.stderr)
        sys.exit(1)

    candidates = data.get("candidates", [])
    if candidates:
        parts = candidates[0].get("content", {}).get("parts", [])
        texts = [p["text"] for p in parts if "text" in p]
        if texts:
            return "\n".join(texts)
    return json.dumps(data, indent=2)


def main():
    if len(sys.argv) < 2:
        print("Usage: python3 gemini_chat.py '<prompt>'", file=sys.stderr)
        sys.exit(1)
    prompt = sys.argv[1]
    api_key = load_api_key()
    model = pick_best_model(api_key)
    print(call_gemini(api_key, model, prompt))


if __name__ == "__main__":
    main()
