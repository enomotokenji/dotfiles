---
name: ask-gemini
description: Ask a single well-formed question to Gemini (Google) and report back its answer plus a short take. Use this whenever the user says "ask Gemini", "geminiにきいて", "geminiに尋ねて", "geminiの意見", "googleの意見を聞いて", or otherwise asks for a one-shot Gemini second opinion — without needing a back-and-forth debate. For anything that warrants several rounds of discussion, use `discuss-gemini` instead.
---

# Ask Gemini

Send one well-formed question to Gemini (Google) and return the answer.

## When to use this vs discuss-gemini

- **ask-gemini**: one-shot — a focused question, a review, a sanity check
- **discuss-gemini**: convergent multi-round debate

If unsure, start with ask-gemini.

## How to talk to Gemini

Use the script bundled with `discuss-gemini` (same script serves both skills):

```bash
python3 ~/.claude/skills/discuss-gemini/scripts/gemini_chat.py "<prompt>"
```

Under Codex: `~/.codex/skills/discuss-gemini/scripts/gemini_chat.py`.

The script reads `GEMINI_API_KEY` from environment, then `$PWD/.env`, then `$HOME/.env`, and picks the strongest available Gemini model.

English prompt; reply to the user in their language.

## Workflow

1. **Gather context.** Read relevant files so the prompt is concrete.
2. **Form the prompt.** Include the question, the minimum context needed, the kind of answer wanted, and a word limit if appropriate.
3. **Invoke.** Bash with timeout 120000 ms+. Heredoc for multi-line; mind shell quoting.
4. **Present.** Show Gemini's answer, then a short take.

## Output shape

```
## Gemini's answer

<verbatim or lightly-trimmed response>

## My take

<1-3 sentences: agree, disagree, or extend — and the concrete next step>
```

## Notes

- If `GEMINI_API_KEY` is missing, the script errors loudly — surface the error and ask the user where to put the key
- No file writeup
