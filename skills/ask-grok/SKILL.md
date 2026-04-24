---
name: ask-grok
description: Ask a single well-formed question to Grok (xAI) and report back its answer plus a short take. Use this whenever the user says "ask Grok", "grokにきいて", "grokに尋ねて", "grokの意見", "xaiにきいて", or otherwise asks for a one-shot Grok second opinion — without needing a back-and-forth debate. For anything that warrants several rounds of discussion, use `discuss-grok` instead.
---

# Ask Grok

Send one well-formed question to Grok (xAI) and return the answer.

## When to use this vs discuss-grok

- **ask-grok**: one-shot — a focused question, a review, a contrarian check
- **discuss-grok**: convergent multi-round debate

If unsure, start with ask-grok.

## How to talk to Grok

Use the script bundled with `discuss-grok`:

```bash
python3 ~/.claude/skills/discuss-grok/scripts/grok_chat.py "<prompt>"
```

Under Codex: `~/.codex/skills/discuss-grok/scripts/grok_chat.py`.

The script reads `XAI_API_KEY` from environment, then `$PWD/.env`, then `$HOME/.env`, and prefers Grok reasoning variants when available.

English prompt; reply to the user in their language.

## Workflow

1. **Gather context.** Read relevant files so the prompt is concrete.
2. **Form the prompt.** Include the question, minimum context, the kind of answer wanted, and a word limit.
3. **Invoke.** Bash with timeout 180000 ms+ (reasoning variants can be slow). Heredoc for multi-line.
4. **Present.** Show Grok's answer, then a short take.

## Output shape

```
## Grok's answer

<verbatim or lightly-trimmed response>

## My take

<1-3 sentences: agree, disagree, or extend — and the concrete next step>
```

## Notes

- If `XAI_API_KEY` is missing, surface the error and ask where to put the key
